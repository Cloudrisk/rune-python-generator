package com.regnosys.rosetta.generator.python.enums

import com.regnosys.rosetta.generator.java.enums.EnumHelper
import com.regnosys.rosetta.generator.python.util.PythonCodeGeneratorUtil
import com.regnosys.rosetta.rosetta.RosettaEnumeration
import com.regnosys.rosetta.rosetta.RosettaModel
import java.util.ArrayList
import java.util.HashMap
import java.util.Map

class PythonEnumGenerator {

    def Map<String, ? extends CharSequence> generate(Iterable<RosettaEnumeration> rosettaEnums, String version) {
        val result = new HashMap
        for (RosettaEnumeration enum : rosettaEnums) {
            val tr = enum.eContainer as RosettaModel
            val namespace = tr.name
            val enums = enum.generateEnums(version).toString.replace('\t', '  ')

            val all = '''
                # pylint: disable=missing-module-docstring, invalid-name, line-too-long
                from enum import Enum
                import rune.runtime.metadata
                
                __all__ = ['«enum.name»']
                
            '''
            result.put(PythonCodeGeneratorUtil::toPyFileName(namespace, enum.name), all + enums)
        }
        return result;
    }

    private def allEnumsValues(RosettaEnumeration enumeration) {
        val enumValues = new ArrayList
        var e = enumeration;

        while (e !== null) {
            e.enumValues.forEach[enumValues.add(it)]
            e = e.parent
        }
        return enumValues.sortBy[name];
    }

    private def generateEnums(RosettaEnumeration enume, String version) {
        '''
        «val allEnumValues = allEnumsValues(enume)»
        class «enume.name»(rune.runtime.metadata.EnumWithMetaMixin, Enum):
            «IF enume.definition!==null»
                """
                «enume.definition»
                """
            «ENDIF»
            «IF allEnumValues.size()===0»
                pass
            «ELSE»
                «FOR value: allEnumValues SEPARATOR ''»
                    «EnumHelper.convertValue(value)» = "«IF value.display !== null»«value.display»«ELSE»«value.name»«ENDIF»"
                    «IF value.definition!==null»
                        """
                        «value.definition»
                        """
                    «ENDIF»
                «ENDFOR»
            «ENDIF»
        '''
    }
}
