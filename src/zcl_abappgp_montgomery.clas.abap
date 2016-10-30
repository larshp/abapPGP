class ZCL_ABAPPGP_MONTGOMERY definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !IO_MODULUS type ref to ZCL_ABAPPGP_INTEGER .
  methods MULTIPLY
    importing
      !IO_X type ref to ZCL_ABAPPGP_MONTGOMERY_INTEGER
      !IO_Y type ref to ZCL_ABAPPGP_MONTGOMERY_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_ABAPPGP_MONTGOMERY_INTEGER .
  methods BUILD
    importing
      !IO_INTEGER type ref to ZCL_ABAPPGP_INTEGER
    returning
      value(RO_MONTGOMERY) type ref to ZCL_ABAPPGP_MONTGOMERY_INTEGER .
  methods UNBUILD
    importing
      !IO_MONTGOMERY type ref to ZCL_ABAPPGP_MONTGOMERY_INTEGER
    returning
      value(RO_INTEGER) type ref to ZCL_ABAPPGP_INTEGER .
protected section.
private section.

  data MO_FACTOR type ref to ZCL_ABAPPGP_INTEGER .
  data MO_MASK type ref to ZCL_ABAPPGP_BINARY_INTEGER .
  data MO_RECIPROCAL type ref to ZCL_ABAPPGP_INTEGER .
  data MO_MODULUS type ref to ZCL_ABAPPGP_INTEGER .
  data MO_REDUCER type ref to ZCL_ABAPPGP_INTEGER .
  data MV_BITS type I .
ENDCLASS.



CLASS ZCL_ABAPPGP_MONTGOMERY IMPLEMENTATION.


  METHOD build.

    DATA: lo_integer TYPE REF TO zcl_abappgp_integer,
          lo_binary  TYPE REF TO zcl_abappgp_binary_integer.


    CREATE OBJECT lo_binary
      EXPORTING
        io_integer = io_integer.

* todo, optimize mod? it is a power of 2...
    lo_integer = lo_binary->shift_left( mv_bits )->to_integer( )->mod( mo_modulus ).

    CREATE OBJECT ro_montgomery
      EXPORTING
        io_integer = lo_integer.

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
    CREATE OBJECT mo_mask
      EXPORTING
        io_integer = lo_tmp.

    mo_reciprocal = mo_reducer->clone( )->mod_inverse( io_modulus ).

    mo_factor = mo_reducer->clone( )->multiply( mo_reciprocal )->subtract( lo_one )->divide( io_modulus ).

  ENDMETHOD.


  METHOD multiply.

    DATA: lo_product TYPE REF TO zcl_abappgp_integer,
          lo_reduced TYPE REF TO zcl_abappgp_integer,
          lo_tmp     TYPE REF TO zcl_abappgp_integer.


    lo_product = io_x->get_integer( )->clone( )->multiply( io_y->get_integer( ) ).

    lo_tmp = lo_product->clone( )->and( mo_mask )->multiply( mo_factor )->and( mo_mask ).

    lo_tmp->multiply( mo_modulus ).

    lo_reduced = lo_product->clone( )->add( lo_tmp )->shift_right( mv_bits ).

    IF lo_reduced->is_gt( mo_modulus ) = abap_true.
      lo_reduced->subtract( mo_modulus ).
    ENDIF.

    CREATE OBJECT ro_result
      EXPORTING
        io_integer = lo_reduced.

  ENDMETHOD.


  METHOD unbuild.

    ro_integer = io_montgomery->get_integer( )->clone( ).
    ro_integer->multiply( mo_reciprocal )->mod( mo_modulus ).

  ENDMETHOD.
ENDCLASS.