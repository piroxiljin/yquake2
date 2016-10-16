# This is a CMake script which works similar to the stringifyshaders.sh 
# i.e. process the ${SHADER_SOURCE} file to a file with C strings literals.
# ${SHADER_DEST} file should be included it that way:
#
# static const char* fragment_shader_main_source = ""
# #include "${SHADER_DEST}"
#	 ;

if ("${SHADER_SOURCE}" STREQUAL "")
	message(FATAL_ERROR "The stringifyshaders.cmake was called without definition of SHADER_SOURCE")
endif()

if ("${SHADER_DEST}" STREQUAL "")
	message(FATAL_ERROR "The stringifyshaders.cmake was called without definition of SHADER_DEST")
endif()

file(STRINGS ${SHADER_SOURCE} SHADER_LINES)

# We need to keep semicolons in a shader source lines during the following steps
string(REPLACE "\;" "\\\\\\\;" SHADER_LINES "${SHADER_LINES}" )

set(SHADER_TEMP_LINES "/* This is an automatically-generated file. Do not edit! */")
list(APPEND SHADER_TEMP_LINES ${SHADER_LINES})

# The original stringifyshaders.sh also escapes backslashes,
# but I'm not sure if it necessary.
# string(REGEX REPLACE "\\\\" "\\\\\\\\" SHADER_TEMP_LINES ${SHADER_TEMP_LINES} )

# append double quotes
foreach(LINE ${SHADER_TEMP_LINES})
	list(APPEND SHADER_OUTPUT_LINES \" "${LINE}" \\n\"\n)
endforeach()

file(WRITE ${SHADER_DEST} ${SHADER_OUTPUT_LINES})
