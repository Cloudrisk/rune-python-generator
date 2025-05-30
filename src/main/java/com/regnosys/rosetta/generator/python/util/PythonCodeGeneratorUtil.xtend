package com.regnosys.rosetta.generator.python.util

import com.regnosys.rosetta.types.RAttribute
import com.regnosys.rosetta.rosetta.RosettaModel;

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class PythonCodeGeneratorUtil {

    static def fileComment(String version) {
        return 
        '''
        # This file is auto-generated from the Rune Python Generator, do not edit.
        # Version: «version»
        
        '''
    }
    static def comment(String definition) {
        return
        '''
        «IF definition !==null && !definition.isEmpty »
            # 
            # «definition»
            #
        «ENDIF»
        '''
    }

    static def classComment(String definition, Iterable<RAttribute> attributes) {
        return
        '''
            «IF definition !==null && !definition.isEmpty »
                #
                # «definition»
                #
                 «FOR attribute : attributes»
                     # @param «attribute.name» «attribute.definition»
                 «ENDFOR»
                #
            «ENDIF»
        '''
    }

    static def String createImports(String name) {
        val imports = 
        '''
            # pylint: disable=line-too-long, invalid-name, missing-function-docstring
            # pylint: disable=bad-indentation, trailing-whitespace, superfluous-parens
            # pylint: disable=wrong-import-position, unused-import, unused-wildcard-import
            # pylint: disable=wildcard-import, wrong-import-order, missing-class-docstring
            # pylint: disable=missing-module-docstring, unused-variable, unnecessary-pass
            
            from __future__ import annotations
            from typing import Optional, Annotated
            import datetime
            import inspect
            from decimal import Decimal
            from pydantic import Field
            from rune.runtime.base_data_class import BaseDataClass
            from rune.runtime.metadata import *
            from rune.runtime.utils import *
            from rune.runtime.conditions import *
            from rune.runtime.func_proxy import *
            __all__ = [«"'"+name+"'"»]
            
        '''
        return imports
    }

    static def String createImports() {
        val imports = 
        '''
            # pylint: disable=line-too-long, invalid-name, missing-function-docstring
            # pylint: disable=bad-indentation, trailing-whitespace, superfluous-parens
            # pylint: disable=wrong-import-position, unused-import, unused-wildcard-import
            # pylint: disable=wildcard-import, wrong-import-order, missing-class-docstring
            # pylint: disable=missing-module-docstring
            from __future__ import annotations
            from typing import Optional, Annotated
            import datetime
            import inspect
            from decimal import Decimal
            from pydantic import Field
            from rune.runtime.base_data_class import BaseDataClass
            from rune.runtime.metadata import *
            from rune.runtime.utils import *
            from rune.runtime.conditions import *
            from rune.runtime.func_proxy import *
        '''
        return imports
    }

    static def String createImportsFunc(String name) {
        val imports = 
        '''
            # pylint: disable=line-too-long, invalid-name, missing-function-docstring, missing-module-docstring, superfluous-parens
            # pylint: disable=wrong-import-position, unused-import, unused-wildcard-import, wildcard-import, wrong-import-order, missing-class-docstring
            from __future__ import annotations
            import sys
            import datetime
            import inspect
            from decimal import Decimal
            from rune.runtime.base_data_class import BaseDataClass
            from rune.runtime.metadata import *
            from rune.runtime.utils import *
            from rune.runtime.conditions import *
            from rune.runtime.func_proxy import *
        '''
        return imports
    }

    static def String toFileName(String namespace, String fileName) {
        '''src/«namespace.replace(".", "/")»/«fileName»''';
    }

    static def String toPyFileName(String namespace, String fileName) {
        '''«toFileName(namespace, fileName)».py''';
    }

    static def String toPyFunctionFileName(String namespace, String fileName) {
        '''src/«namespace.replace(".", "/")»/functions/«fileName».py''';
    }

    static def String createTopLevelInitFile(String version) {
        return "from .version import __version__"
    }

    static def String createVersionFile(String version) {
        val versionComma = version.replace('.', ',')
        return "version = (" + versionComma + ",0)\n" + 
                           "version_str = '" + version + "-0'\n" +
                           "__version__ = '" + version + "'\n" + 
                           "__build_time__ = '" + LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME) + "'"
    }
    static def String getNamespace(RosettaModel rm) {
    	return rm.name.split("\\.").get(0)
    }

    static def String createPYProjectTomlFile(String namespace, String version) {
        return '[build-system]\n' + 
                "requires = [\"setuptools>=62.0\"]\n" +
                "build-backend = \"setuptools.build_meta\"\n\n" + 
                "[project]\n" + 
                "name = \"python-" + namespace + "\"\n" +
                "version = \"" + version + "\"\n" + 
                "requires-python = \">= 3.11\"\n" + 
                "dependencies = [\n" + "   \"pydantic>=2.10.3\",\n" + "   \"rune.runtime>=1.0.0,<1.1.0\"\n" + "]\n" + "[tool.setuptools.packages.find]\n" + "where = [\"src\"]"
    }
}
