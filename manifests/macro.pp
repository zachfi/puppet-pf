# This define creates a pf macro with a given key and string value
#
# @param $key The variable name of of the macro
# @param $value The value of the macro to store at the variable
#
define pf::macro (
  String $value,
  String $key = $name,
) {
  include pf

  concat::fragment { "${name}.pf":
    target  => "${pf::pf_d}/macros.pf",
    content => "${key} = ${value}\n",
  }
}
