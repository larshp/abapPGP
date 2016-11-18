INTERFACE zif_abappgp_constants
  PUBLIC .


  TYPES ty_algorithm_pub TYPE x LENGTH 1.
  TYPES ty_algorithm_sym TYPE x LENGTH 1.
  TYPES ty_version TYPE x LENGTH 1.
  TYPES ty_tag TYPE i .

  CONSTANTS:
    BEGIN OF c_algorithm_pub,
      rsa TYPE ty_algorithm_pub VALUE '01',
    END OF c_algorithm_pub.

  CONSTANTS:
    BEGIN OF c_version,
      version03 TYPE ty_algorithm_pub VALUE '03',
      version04 TYPE ty_algorithm_pub VALUE '04',
    END OF c_version.

  CONSTANTS:
    BEGIN OF c_tag,
      public_key_enc         TYPE ty_tag VALUE 1,
      signature              TYPE ty_tag VALUE 2,
      symmetric_key_enc      TYPE ty_tag VALUE 3,
      one_pass               TYPE ty_tag VALUE 4,
      secret_key             TYPE ty_tag VALUE 5,
      public_key             TYPE ty_tag VALUE 6,
      secret_subkey          TYPE ty_tag VALUE 7,
      compressed_data        TYPE ty_tag VALUE 8,
      symmetrical_enc        TYPE ty_tag VALUE 9,
      marker                 TYPE ty_tag VALUE 10,
      literal                TYPE ty_tag VALUE 11,
      trust                  TYPE ty_tag VALUE 12,
      user_id                TYPE ty_tag VALUE 13,
      public_subkey          TYPE ty_tag VALUE 14,
      user_attribute         TYPE ty_tag VALUE 17,
      symmetrical_inte       TYPE ty_tag VALUE 18,
      modification_detection TYPE ty_tag VALUE 19,
    END OF c_tag .
ENDINTERFACE.