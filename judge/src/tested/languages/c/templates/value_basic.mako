## Convert a Value to a literal type in Java.
<%! from tested.datatypes import BasicNumericTypes, BasicStringTypes, BasicBooleanTypes, BasicNothingTypes, BasicSequenceTypes, BasicObjectTypes  %>
<%page args="value" />
% if value.type == BasicNumericTypes.INTEGER:
    ${value.data}\
% elif value.type == BasicNumericTypes.RATIONAL:
    ${value.data}
% elif value.type == BasicStringTypes.TEXT:
    "${value.data}"\
% elif value.type == BasicStringTypes.CHAR:
    '${value.data}'\
% elif value.type == BasicBooleanTypes.BOOLEAN:
    ${str(value.data).lower()}\
% elif value.type == BasicNothingTypes.NOTHING:
    NULL\
% elif value.type == BasicSequenceTypes.SEQUENCE:
    // TODO
    // List.of(<%include file="value_arguments.mako" args="arguments=value.data" />)\
% endif
