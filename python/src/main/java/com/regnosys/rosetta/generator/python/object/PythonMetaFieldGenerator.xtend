package com.regnosys.rosetta.generator.python.object

import com.google.inject.Inject

import com.regnosys.rosetta.rosetta.RosettaMetaType
import com.regnosys.rosetta.rosetta.simple.Data
import com.regnosys.rosetta.types.RType
import com.regnosys.rosetta.types.REnumType
import java.util.List

import com.regnosys.rosetta.types.RObjectFactory
import com.regnosys.rosetta.types.RChoiceType
import com.regnosys.rosetta.types.RAttribute

import static extension com.regnosys.rosetta.generator.python.object.PythonModelObjectBoilerPlate.*
import static extension com.regnosys.rosetta.generator.python.util.PythonTranslator.*
import static extension com.regnosys.rosetta.generator.util.IterableUtil.*
import com.regnosys.rosetta.generator.python.util.PythonModelGeneratorUtil
import java.util.Set

class PythonMetaFieldGenerator {

    @Inject extension RObjectFactory

    def generateMetaFields(List<Data> rosettaClasses, Iterable<RosettaMetaType> metaTypes, String version) {
/*
 * 
         val metaFieldsImports = generateMetaFieldsImports.toString

         val refs = rosettaClasses
                .flatMap[expandedAttributes]
                 .filter[hasMetas && metas.exists[name=="reference" || name=="address"]]
                .map[type]
                .toSet

        var referenceWithMeta = '';

        for (ref : refs) {
            if (ref.isType)
                referenceWithMeta += generateReferenceWithMeta(ref).toString
            else
                referenceWithMeta += generateBasicReferenceWithMeta(ref).toString
        }

        val metas =  rosettaClasses
                .flatMap[expandedAttributes]
                .filter[hasMetas && !metas.exists[name=="reference" || name=="address"]]
                .map[type]
                .toSet

        for (meta:metas) {
            referenceWithMeta += generateFieldWithMeta(meta).toString
        }

        val metaFields = genMetaFields(metaTypes.filter[t|t.name!="id" && t.name!="key" && t.name!="reference" && t.name!="address"], version)

        return PythonModelGeneratorUtil::fileComment(version) + metaFieldsImports + referenceWithMeta + metaFields
     */   
     }

    private def generateMetaFieldsImports() 
    '''
    '''

    private def generateFieldWithMeta (RType rt) 
    '''
    class FieldWithMeta«rt.toMetaTypeName»:
        «generateAttribute(rt)»
        meta = MetaFields()

    '''
/*
    private def generateFieldWithMeta(ExpandedType type) '''
    class FieldWithMeta«type.toMetaTypeName»:
        «generateAttribute(type)»
        meta = MetaFields()

    '''
 */
    private def generateAttribute(RType rt) {
        return (rt instanceof REnumType) ? '''value = «rt.toPythonType»''' : '''value = None'''
    }
/*
    private def generateAttribute(ExpandedType type) {
        if (type.enumeration) {
            '''value = «type.toPythonType»'''
        } else {
            '''value = None'''
        }
    }
 */

    private def generateReferenceWithMeta (RType rt)
    '''
    class ReferenceWithMeta«rt.toMetaTypeName»:
        value = «rt.name»()
        globalReference = None
        externalReference = None
        address = Reference()

    '''
/*
    private def generateReferenceWithMeta(ExpandedType type)
    '''
    class ReferenceWithMeta«type.toMetaTypeName»:
        value = «type.name»()
        globalReference = None
        externalReference = None
        address = Reference()

    '''
    * 
    */
    private def generateBasicReferenceWithMeta (RType rt)
    '''
    class BasicReferenceWithMeta«rt.toMetaTypeName»:
        value = None
        globalReference = None
        externalReference = None
        address = Reference()

    '''
    /*
    private def generateBasicReferenceWithMeta(ExpandedType type)
    '''
    class BasicReferenceWithMeta«type.toMetaTypeName»:
        value = None
        globalReference = None
        externalReference = None
        address = Reference()

    '''
     */

    private def genMetaFields(Iterable<RosettaMetaType> types, String version) 
    '''
    class MetaFields:
        «FOR type : types.distinctBy(t|t.name.toFirstLower) SEPARATOR '\n'»«type.name.toFirstLower» = None«ENDFOR»
        globalKey = None
        externalKey = None
        location = []


    class MetaAndTemplateFields:
        «FOR type : types.distinctBy(t|t.name.toFirstLower) SEPARATOR '\n'»«type.name.toFirstLower» = None«ENDFOR»
        globalKey = None
        externalKey = None
        templateGlobalReference = None
        location = []


    class Key:
        scope = None
        value = None

    
    class Reference:
        scope = None
        value = None

    '''
}