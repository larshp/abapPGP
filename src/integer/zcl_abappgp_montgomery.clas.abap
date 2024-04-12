CLASS zcl_abappgp_montgomery DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !io_modulus TYPE REF TO zcl_abappgp_integer .
    METHODS multiply
      IMPORTING
        !io_x            TYPE REF TO zcl_abappgp_montgomery_integer
        !io_y            TYPE REF TO zcl_abappgp_montgomery_integer
      RETURNING
        VALUE(ro_result) TYPE REF TO zcl_abappgp_montgomery_integer .
    METHODS build
      IMPORTING
        !io_integer          TYPE REF TO zcl_abappgp_integer
      RETURNING
        VALUE(ro_montgomery) TYPE REF TO zcl_abappgp_montgomery_integer .
    METHODS unbuild
      IMPORTING
        !io_montgomery    TYPE REF TO zcl_abappgp_montgomery_integer
      RETURNING
        VALUE(ro_integer) TYPE REF TO zcl_abappgp_integer .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_factor TYPE REF TO zcl_abappgp_integer2 .
    DATA mo_mask TYPE REF TO zcl_abappgp_integer2 .
    DATA mo_reciprocal TYPE REF TO zcl_abappgp_integer .
    DATA mo_modulus2 TYPE REF TO zcl_abappgp_integer2 .
    DATA mo_modulus TYPE REF TO zcl_abappgp_integer .
    DATA mo_reducer TYPE REF TO zcl_abappgp_integer .
    DATA mv_bits TYPE i .
ENDCLASS.



CLASS zcl_abappgp_montgomery IMPLEMENTATION.


  METHOD build.

    DATA: lo_integer TYPE REF TO zcl_abappgp_integer,
          lo_binary  TYPE REF TO zcl_abappgp_binary_integer.


    CREATE OBJECT lo_binary
      EXPORTING
        io_integer = io_integer.

* todo, optimize mod? it is a power of 2...
* todo, no need to convert to binary? can do shift_left in zcl_abappgp_integer2?
    lo_integer = lo_binary->shift_left( mv_bits )->to_integer( ).
    lo_integer = lo_integer->mod( mo_modulus ).

    CREATE OBJECT ro_montgomery
      EXPORTING
        io_integer = zcl_abappgp_integer2=>from_integer( lo_integer ).

  ENDMETHOD.


  METHOD constructor.

* https://en.wikipedia.org/wiki/Montgomery_modular_multiplication
* https://alicebob.cryptoland.net/understanding-the-montgomery-reduction-algorithm/
* https://www.nayuki.io/page/montgomery-reduction-algorithm

    DATA: lo_binary TYPE REF TO zcl_abappgp_binary_integer,
          lo_tmp    TYPE REF TO zcl_abappgp_integer,
          lo_one    TYPE REF TO zcl_abappgp_integer.


    ASSERT io_modulus->is_even( ) = abap_false.
    ASSERT io_modulus->is_zero( ) = abap_false.
    ASSERT io_modulus->is_one( ) = abap_false.
    ASSERT io_modulus->is_two( ) = abap_false.

    mo_modulus = io_modulus->clone( ).
    mo_modulus2 = zcl_abappgp_integer2=>from_integer( mo_modulus ).

    CREATE OBJECT lo_binary
      EXPORTING
        io_integer = io_modulus.
    mv_bits = ( lo_binary->get_binary_length( ) DIV 8 + 1 ) * 8.

    CREATE OBJECT lo_one.
    CREATE OBJECT lo_binary
      EXPORTING
        io_integer = lo_one.
    lo_binary->shift_left( mv_bits ).
    mo_reducer = lo_binary->to_integer( ).

    lo_tmp = mo_reducer->clone( )->subtract( lo_one ).
    mo_mask = zcl_abappgp_integer2=>from_integer( lo_tmp ).

    mo_reciprocal = mo_reducer->clone( )->mod_inverse( io_modulus ).

    mo_factor = zcl_abappgp_integer2=>from_integer(
      mo_reducer->clone( )->multiply( mo_reciprocal )->subtract(
      lo_one )->divide_knuth( io_modulus ) ).

  ENDMETHOD.


  METHOD multiply.

    DATA: lo_product TYPE REF TO zcl_abappgp_integer2,
          lo_reduced TYPE REF TO zcl_abappgp_integer2,
          lo_tmp     TYPE REF TO zcl_abappgp_integer2.


    lo_product = io_x->get_integer( )->clone( )->multiply_karatsuba( io_y->get_integer( ) ).

    lo_tmp = lo_product->clone( )->and( mo_mask )->multiply_karatsuba( mo_factor )->and( mo_mask ).

    lo_tmp->multiply_karatsuba( mo_modulus2 ).

    lo_reduced = lo_product->add( lo_tmp )->shift_right( mv_bits ).

    IF lo_reduced->is_gt( mo_modulus2 ) = abap_true.
      lo_reduced->subtract( mo_modulus2 ).
    ENDIF.

    CREATE OBJECT ro_result
      EXPORTING
        io_integer = lo_reduced.

  ENDMETHOD.


  METHOD unbuild.

    ro_integer = io_montgomery->get_integer( )->to_integer( ).
    ro_integer->multiply( mo_reciprocal )->mod( mo_modulus ).

  ENDMETHOD.
ENDCLASS.
