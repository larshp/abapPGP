INTERFACE zif_abappgp_constants PUBLIC.

  TYPES ty_algorithm_pub TYPE x LENGTH 1.
  TYPES ty_algorithm_sym TYPE x LENGTH 1.
  TYPES ty_algorithm_hash TYPE x LENGTH 1.
  TYPES ty_signature TYPE x LENGTH 1.
  TYPES ty_s2k_type TYPE x LENGTH 1.
  TYPES ty_version TYPE x LENGTH 1.
  TYPES ty_tag TYPE i .
  TYPES ty_sub_type TYPE i .

  TYPES ty_packet_list TYPE STANDARD TABLE OF REF TO zif_abappgp_packet WITH DEFAULT KEY .
  TYPES ty_algorithms TYPE STANDARD TABLE OF ty_algorithm_pub WITH DEFAULT KEY.

  CONSTANTS:
    BEGIN OF c_algorithm_pub,
      rsa TYPE ty_algorithm_pub VALUE '01',
    END OF c_algorithm_pub.

  CONSTANTS: BEGIN OF c_s2k_type,
               simple          TYPE ty_s2k_type VALUE '00',
               salted          TYPE ty_s2k_type VALUE '01',
               iterated_salted TYPE ty_s2k_type VALUE '03',
             END OF c_s2k_type.

  CONSTANTS: BEGIN OF c_algorithm_hash,
               md5    TYPE ty_algorithm_hash VALUE '01',
               sha1   TYPE ty_algorithm_hash VALUE '02',
               ripe   TYPE ty_algorithm_hash VALUE '03',
               sha256 TYPE ty_algorithm_hash VALUE '08',
               sha384 TYPE ty_algorithm_hash VALUE '09',
               sha512 TYPE ty_algorithm_hash VALUE '10',
               sha224 TYPE ty_algorithm_hash VALUE '11',
             END OF c_algorithm_hash.

  CONSTANTS:
    BEGIN OF c_algorithm_sym,
      idea      TYPE ty_algorithm_sym VALUE '01',
      tripledes TYPE ty_algorithm_sym VALUE '02',
      cast5     TYPE ty_algorithm_sym VALUE '03',
      blowfish  TYPE ty_algorithm_sym VALUE '04',
      aes128    TYPE ty_algorithm_sym VALUE '07',
      aes192    TYPE ty_algorithm_sym VALUE '08',
      aes256    TYPE ty_algorithm_sym VALUE '09',
      twofish   TYPE ty_algorithm_sym VALUE '10',
    END OF c_algorithm_sym.

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

  CONSTANTS:
    BEGIN OF c_sub_type,
      signature_creation_time   TYPE ty_sub_type VALUE 2,
      signature_expiration_time TYPE ty_sub_type VALUE 3,
      exportable_certification  TYPE ty_sub_type VALUE 4,
      trust_signature           TYPE ty_sub_type VALUE 5,
      regular_expression        TYPE ty_sub_type VALUE 6,
      revocable                 TYPE ty_sub_type VALUE 7,
      key_expiration_time       TYPE ty_sub_type VALUE 9,
      placeholder_for_backward  TYPE ty_sub_type VALUE 10,
      preferred_symmetric       TYPE ty_sub_type VALUE 11,
      revocation_key            TYPE ty_sub_type VALUE 12,
      issuer                    TYPE ty_sub_type VALUE 16,
      notation_data             TYPE ty_sub_type VALUE 20,
      preferred_hash_algorithms TYPE ty_sub_type VALUE 21,
      preferred_compression     TYPE ty_sub_type VALUE 22,
      key_server_preferences    TYPE ty_sub_type VALUE 23,
      preferred_key_server      TYPE ty_sub_type VALUE 24,
      primary_user_id           TYPE ty_sub_type VALUE 25,
      policy_uri                TYPE ty_sub_type VALUE 26,
      key_flags                 TYPE ty_sub_type VALUE 27,
      signers_user_id           TYPE ty_sub_type VALUE 28,
      reason_for_revocation     TYPE ty_sub_type VALUE 29,
      features                  TYPE ty_sub_type VALUE 30,
      signature_target          TYPE ty_sub_type VALUE 31,
      embedded_signature        TYPE ty_sub_type VALUE 32,
    END OF c_sub_type .

ENDINTERFACE.
