package com.regnosys.rosetta.generator.python.expression

import jakarta.inject.Inject
import com.regnosys.rosetta.tests.RosettaInjectorProvider
import com.regnosys.rosetta.generator.python.PythonGeneratorTestUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.junit.jupiter.api.Disabled

@ExtendWith(InjectionExtension)
@InjectWith(RosettaInjectorProvider)

class RosettaExistsExpressionTest {
    
    @Inject PythonGeneratorTestUtils testUtils
    @Disabled    
    @Test
    def void setUp() {
        val pythonString = testUtils.generatePythonFromString(
            '''
            type Foo:
                bar Bar (0..*)
                baz Baz (0..1)
            
            type Bar:
                before number (0..1)
                after number (0..1)
                other number (0..1)
                beforeWithScheme number (0..1)
                    [metadata scheme]
                afterWithScheme number (0..1)
                    [metadata scheme]
                beforeList number (0..*)
                afterList number (0..*)
                beforeListWithScheme number (0..*)
                    [metadata scheme]
                afterListWithScheme number (0..*)
                    [metadata scheme]
            
            type Baz:
                bazValue number (0..1)
                other number (0..1)
            
            func Exists:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    foo -> bar -> before exists
            
            func SingleExists:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    foo -> bar -> before single exists

            func MultipleExists:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    foo -> bar -> before multiple exists

            func OnlyExists:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    foo -> bar -> before only exists
            
            func OnlyExistsMultiplePaths:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    ( foo -> bar -> before, foo -> bar -> after ) only exists

            func OnlyExistsPathWithScheme:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    ( foo -> bar -> before, foo -> bar -> afterWithScheme ) only exists
            
            func OnlyExistsBothPathsWithScheme:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    ( foo -> bar -> beforeWithScheme, foo -> bar -> afterWithScheme ) only exists

            func OnlyExistsListMultiplePaths:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    ( foo -> bar -> before, foo -> bar -> afterList ) only exists

            func OnlyExistsListPathWithScheme:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    ( foo -> bar -> before, foo -> bar -> afterListWithScheme ) only exists
            
            func OnlyExistsListBothPathsWithScheme:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    ( foo -> bar -> beforeListWithScheme, foo -> bar -> afterListWithScheme ) only exists

«««            TODO tests compilation only, add unit test
            func MultipleSeparateOr_NoAliases_Exists:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    foo -> bar -> before exists or foo -> bar -> after exists

«««         TODO tests compilation only, add unit test
            func MultipleOr_NoAliases_Exists:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    foo -> bar -> before exists or foo -> bar -> after exists or foo -> baz -> other exists
            
«««         TODO tests compilation only, add unit test
            func MultipleOrBranchNode_NoAliases_Exists:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    foo -> bar exists or foo -> baz exists
            
«««         TODO tests compilation only, add unit test
            func MultipleAnd_NoAliases_Exists:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    foo -> bar -> before exists and foo -> bar -> after exists and foo -> baz -> other exists
            
«««            TODO tests compilation only, add unit test
            func MultipleOrAnd_NoAliases_Exists:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    foo -> bar -> before exists or ( foo -> bar -> after exists and foo -> baz -> other exists )
            
«««            TODO tests compilation only, add unit test
            func MultipleOrAnd_NoAliases_Exists2:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    (foo -> bar -> before exists and foo -> bar -> after exists) or foo -> baz -> other exists or foo -> baz -> bazValue exists
            
«««            TODO tests compilation only, add unit test
            func MultipleOrAnd_NoAliases_Exists3:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    (foo -> bar -> before exists or foo -> bar -> after exists) or (foo -> baz -> other exists and foo -> baz -> bazValue exists)
            
«««            TODO tests compilation only, add unit test
            func MultipleExistsWithOrAnd:
                inputs: foo Foo (1..1)
                output: result boolean (1..1)
                set result:
                    foo -> bar -> before exists or ( foo -> baz -> other exists and foo -> bar -> after exists ) or foo -> baz -> bazValue exists
            ''').toString()
    }
}