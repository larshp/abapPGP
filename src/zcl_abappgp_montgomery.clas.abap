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


    ASSERT NOT io_modulus->is_even( ).
    ASSERT NOT io_modulus->is_zero( ).
    ASSERT NOT io_modulus->is_one( ).
    ASSERT NOT io_modulus->is_two( ).

    CREATE OBJECT mo_modulus.
    mo_modulus->copy( io_modulus ).

    CREATE OBJECT lo_binary
      EXPORTING
        io_integer = io_modulus.
    mv_bits = ( strlen( lo_binary->get( ) ) DIV 8 + 1 ) * 8.

    CREATE OBJECT lo_one.
    CREATE OBJECT lo_binary
      EXPORTING
        io_integer = lo_one.
    lo_binary->shift_left( mv_bits ).
    mo_reducer = lo_binary->to_integer( ).

    CREATE OBJECT lo_tmp.
    lo_tmp->copy( mo_reducer )->subtract( lo_one ).
    CREATE OBJECT mo_mask
      EXPORTING
        io_integer = lo_tmp.

    CREATE OBJECT mo_reciprocal.
    mo_reciprocal->copy( mo_reducer )->mod_inverse( io_modulus ).

    CREATE OBJECT mo_factor.
    mo_factor->copy( mo_reducer )->multiply( mo_reciprocal )->subtract( lo_one )->divide( io_modulus ).

  ENDMETHOD.


  METHOD multiply.

    DATA: lo_product TYPE REF TO zcl_abappgp_integer,
          lo_tmp     TYPE REF TO zcl_abappgp_integer.


    CREATE OBJECT lo_product.
    lo_product->copy( io_x->get( ) )->multiply( io_y->get( ) ).

    CREATE OBJECT lo_tmp.
* todo, optimize 'mod' to 'and'?
    lo_tmp->copy( lo_product )->and( mo_mask )->multiply( mo_factor )->and( mo_mask ).
    BREAK-POINT.

  ENDMETHOD.


  METHOD unbuild.

* todo

  ENDMETHOD.
ENDCLASS.