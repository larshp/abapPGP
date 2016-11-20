class ZCL_ABAPPGP_STRING_TO_KEY definition
  public
  create public .

public section.

  class-methods FROM_STREAM
    importing
      !IO_STREAM type ref to ZCL_ABAPPGP_STREAM
    returning
      value(RO_S2K) type ref to ZCL_ABAPPGP_STRING_TO_KEY .
  methods CONSTRUCTOR
    importing
      !IV_TYPE type ZIF_ABAPPGP_CONSTANTS=>TY_S2K_TYPE
      !IV_HASH type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_HASH
      !IV_SALT type XSEQUENCE
      !IV_COUNT type I .
  methods DUMP
    returning
      value(RV_DUMP) type STRING .
  methods TO_STREAM
    returning
      value(RO_STREAM) type ref to ZCL_ABAPPGP_STREAM .
protected section.

  data MV_TYPE type ZIF_ABAPPGP_CONSTANTS=>TY_S2K_TYPE .
  data MV_HASH type ZIF_ABAPPGP_CONSTANTS=>TY_ALGORITHM_HASH .
  data MV_SALT type XSTRING .
  data MV_COUNT type I .
private section.
ENDCLASS.



CLASS ZCL_ABAPPGP_STRING_TO_KEY IMPLEMENTATION.


  METHOD constructor.
* https://tools.ietf.org/html/rfc4880#section-3.7

* todo, refactor to 1 class per type?

    ASSERT iv_type = zif_abappgp_constants=>c_s2k_type-simple
      OR iv_type = zif_abappgp_constants=>c_s2k_type-salted
      OR iv_type = zif_abappgp_constants=>c_s2k_type-iterated_salted.

    mv_type  = iv_type.
    mv_hash  = iv_hash.
    mv_salt  = iv_salt.
    mv_count = iv_count.

  ENDMETHOD.


  METHOD dump.

    rv_dump = |\tString to key specifier(type { mv_type })\n|.

    CASE mv_type.
      WHEN zif_abappgp_constants=>c_s2k_type-simple.
* todo
        ASSERT 0 = 1.
      WHEN zif_abappgp_constants=>c_s2k_type-salted.
* todo
        ASSERT 0 = 1.
      WHEN zif_abappgp_constants=>c_s2k_type-iterated_salted.
        rv_dump = |{ rv_dump }\t\tHash alg\t{
          mv_hash }\n\t\tSalt\t{
          mv_salt }\n\t\tCount\t{ mv_count }\n|.
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

  ENDMETHOD.


  METHOD from_stream.

    DATA: lv_type  TYPE zif_abappgp_constants=>ty_s2k_type,
          lv_salt  TYPE x LENGTH 8,
          lv_count TYPE i,
          lv_hash  TYPE zif_abappgp_constants=>ty_algorithm_hash.


    lv_type = io_stream->eat_octet( ).

    CASE lv_type.
      WHEN zif_abappgp_constants=>c_s2k_type-simple.
* todo
        ASSERT 0 = 1.
      WHEN zif_abappgp_constants=>c_s2k_type-salted.
* todo
        ASSERT 0 = 1.
      WHEN zif_abappgp_constants=>c_s2k_type-iterated_salted.
        lv_hash = io_stream->eat_octet( ).
        lv_salt = io_stream->eat_octets( 8 ).
        lv_count = io_stream->eat_octet( ).
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

    CREATE OBJECT ro_s2k
      EXPORTING
        iv_type  = lv_type
        iv_hash  = lv_hash
        iv_salt  = lv_salt
        iv_count = lv_count.

  ENDMETHOD.


  METHOD to_stream.

    DATA: lv_octet TYPE x LENGTH 1.


    CREATE OBJECT ro_stream.
    ro_stream->write_octet( mv_type ).

    CASE mv_type.
      WHEN zif_abappgp_constants=>c_s2k_type-simple.
* todo
        ASSERT 0 = 1.
      WHEN zif_abappgp_constants=>c_s2k_type-salted.
* todo
        ASSERT 0 = 1.
      WHEN zif_abappgp_constants=>c_s2k_type-iterated_salted.
        ro_stream->write_octet( mv_hash ).
        ro_stream->write_octets( mv_salt ).
        lv_octet = mv_count.
        ro_stream->write_octet( lv_octet ).
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.