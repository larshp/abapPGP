CLASS zcl_abappgp_string_to_key DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS from_stream
      IMPORTING
        !io_stream    TYPE REF TO zcl_abappgp_stream
      RETURNING
        VALUE(ro_s2k) TYPE REF TO zcl_abappgp_string_to_key .
    METHODS constructor
      IMPORTING
        !iv_type  TYPE zif_abappgp_constants=>ty_s2k_type
        !iv_hash  TYPE zif_abappgp_constants=>ty_algorithm_hash
        !iv_salt  TYPE xsequence
        !iv_count TYPE i .
    METHODS dump
      RETURNING
        VALUE(rv_dump) TYPE string .
    METHODS to_stream
      RETURNING
        VALUE(ro_stream) TYPE REF TO zcl_abappgp_stream .
    METHODS build_key
      IMPORTING
        !iv_password  TYPE clike
      RETURNING
        VALUE(rv_key) TYPE xstring .
  PROTECTED SECTION.

    DATA mv_type TYPE zif_abappgp_constants=>ty_s2k_type .
    DATA mv_hash TYPE zif_abappgp_constants=>ty_algorithm_hash .
    DATA mv_salt TYPE xstring .
    DATA mv_count TYPE i .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ABAPPGP_STRING_TO_KEY IMPLEMENTATION.


  METHOD build_key.

    DATA: lv_length   TYPE i,
          lv_pass     TYPE xstring,
          lv_password TYPE string,
          lv_input    TYPE xstring.


    ASSERT mv_type = zif_abappgp_constants=>c_s2k_type-iterated_salted.
    ASSERT mv_hash = zif_abappgp_constants=>c_algorithm_hash-sha256.

    lv_password = iv_password.
    lv_pass = zcl_abappgp_convert=>string_to_utf8( lv_password ).

    CASE mv_count.
      WHEN '96'.
        lv_length = 65536.
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

    WHILE xstrlen( lv_input ) < lv_length.
      CONCATENATE lv_input mv_salt lv_pass INTO lv_input IN BYTE MODE.
    ENDWHILE.
    lv_input = lv_input(lv_length).

    CASE mv_hash.
      WHEN zif_abappgp_constants=>c_algorithm_hash-sha256.
        rv_key = zcl_abappgp_hash=>sha256( lv_input ).
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

  ENDMETHOD.


  METHOD constructor.
* https://tools.ietf.org/html/rfc4880#section-3.7

* todo, refactor to 1 class per type s2k?

    ASSERT iv_type = zif_abappgp_constants=>c_s2k_type-simple
      OR iv_type = zif_abappgp_constants=>c_s2k_type-salted
      OR iv_type = zif_abappgp_constants=>c_s2k_type-iterated_salted.

    ASSERT iv_hash = zif_abappgp_constants=>c_algorithm_hash-sha256.

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
          mv_hash }\n\t\tSalt\t\t{
          mv_salt }\n\t\tCount\t\t{ mv_count }\n|.
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
