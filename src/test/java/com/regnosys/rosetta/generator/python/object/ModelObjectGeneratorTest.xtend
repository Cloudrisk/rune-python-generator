package com.regnosys.rosetta.generator.python.object

import com.google.inject.Inject
import com.regnosys.rosetta.generator.python.PythonCodeGenerator
import com.regnosys.rosetta.generator.python.PythonGeneratorTestUtils

import com.regnosys.rosetta.tests.RosettaInjectorProvider
import com.regnosys.rosetta.tests.util.ModelHelper
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import static org.junit.jupiter.api.Assertions.*

@ExtendWith(InjectionExtension)
@InjectWith(RosettaInjectorProvider)

class ModelObjectGeneratorTest {

    @Inject extension ModelHelper
    @Inject PythonCodeGenerator generator;
    @Inject PythonGeneratorTestUtils testUtils

    @Test
    def void testGenerateBasicTypeString() {
        testUtils.assertBundleContainsExpectedString (
            '''
            type Tester:
                one string (0..1)
                list string (1..*)
            ''',
            '''
            class com_rosetta_test_model_Tester(BaseDataClass):
                one: Optional[str] = Field(None, description='')
                list: list[str] = Field([], description='', min_length=1)'''
        )
    }

    @Test
    def void testGenerateBasicTypeInt() {
        val python = testUtils.generatePythonFromString('''
            type Tester:
                one int (0..1)
                list int (1..*)
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expected =
        '''
        class com_rosetta_test_model_Tester(BaseDataClass):
            one: Optional[int] = Field(None, description='')
            list: list[int] = Field([], description='', min_length=1)'''
        assertTrue(_bundle.contains(expected), "expected\n" + expected + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testGenerateBasicTypeNumber() {
        val python = testUtils.generatePythonFromString('''
            type Tester:
                one number (0..1)
                list number (1..*)
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expected =
        '''
        class com_rosetta_test_model_Tester(BaseDataClass):
            one: Optional[Decimal] = Field(None, description='')
            list: list[Decimal] = Field([], description='', min_length=1)'''
        assertTrue(_bundle.contains(expected), "expected\n" + expected + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testGenerateBasicTypeBoolean() {
        val python = testUtils.generatePythonFromString('''
            type Tester:
                one boolean (0..1)
                list boolean (1..*)
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expected =
        '''
        class com_rosetta_test_model_Tester(BaseDataClass):
            one: Optional[bool] = Field(None, description='')
            list: list[bool] = Field([], description='', min_length=1)'''
        assertTrue(_bundle.contains(expected), "expected\n" + expected + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testGenerateBasicTypeDate() {
        val python = testUtils.generatePythonFromString('''
            type Tester:
                one date (0..1)
                list date (1..*)
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expected =
        '''
        class com_rosetta_test_model_Tester(BaseDataClass):
            one: Optional[datetime.date] = Field(None, description='')
            list: list[datetime.date] = Field([], description='', min_length=1)'''
        assertTrue(_bundle.contains(expected), "expected\n" + expected + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testGenerateBasicTypeDateTime() {
        val python = testUtils.generatePythonFromString('''
            type Tester:
                one date (0..1)
                list date (1..*)
                zoned zonedDateTime (0..1)
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expected =
        '''
        class com_rosetta_test_model_Tester(BaseDataClass):
            one: Optional[datetime.date] = Field(None, description='')
            list: list[datetime.date] = Field([], description='', min_length=1)
            zoned: Optional[datetime.datetime] = Field(None, description='')'''
        assertTrue(_bundle.contains(expected), "expected\n" + expected + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testGenerateBasicTypeTime() {
        val python = testUtils.generatePythonFromString('''
            type Tester:
                one time (0..1)
                list time (1..*)
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expected =
        '''
        class com_rosetta_test_model_Tester(BaseDataClass):
            one: Optional[datetime.time] = Field(None, description='')
            list: list[datetime.time] = Field([], description='', min_length=1)'''
        assertTrue(_bundle.contains(expected), "expected\n" + expected + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testOmitGlobalKeyAnnotationWhenNotDefined() {
        val python = testUtils.generatePythonFromString('''
            type AttributeGlobalKeyTest:
                withoutGlobalKey string (1..1)
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expected =
        '''
        class com_rosetta_test_model_AttributeGlobalKeyTest(BaseDataClass):
            withoutGlobalKey: str = Field(..., description='')'''
        assertTrue(_bundle.contains(expected), "expected\n" + expected + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testGenerateClasslist() {
        val python = testUtils.generatePythonFromString('''
            type A extends B:
                c C (1..*)

            type B:

            type C :
                one int (0..1)
                list int (1..*)

            type D:
                s string (1..*)
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expectedA =
        '''
        class com_rosetta_test_model_A(com_rosetta_test_model_B):
            c: list[Annotated[com_rosetta_test_model_C, com_rosetta_test_model_C.serializer(), com_rosetta_test_model_C.validator()]] = Field([], description='', min_length=1)'''

        val expectedB=
        '''
        class com_rosetta_test_model_B(BaseDataClass):
            pass'''

        val expectedC =
        '''
        class com_rosetta_test_model_C(BaseDataClass):
            one: Optional[int] = Field(None, description='')
            list: list[int] = Field([], description='', min_length=1)'''

        val expectedD =
        '''
        class com_rosetta_test_model_D(BaseDataClass):
            s: list[str] = Field([], description='', min_length=1)'''
        assertTrue(_bundle.contains(expectedA), "expectedA\n" + expectedA + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedB), "expectedB\n" + expectedB + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedC), "expectedC\n" + expectedC + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedD), "expectedD\n" + expectedD + "\n_bundle\n" + _bundle)
            
    }

    @Test
    def void testExtendATypeWithSameAttribute() {
        val python = testUtils.generatePythonFromString('''
            type Foo:
                a string (0..1)
                b string (0..1)
            
            type Bar extends Foo:
                a string (0..1)
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()

        val expectedFoo=
        '''
        class com_rosetta_test_model_Foo(BaseDataClass):
            a: Optional[str] = Field(None, description='')
            b: Optional[str] = Field(None, description='')'''

        val expectedBar =
        '''
        class com_rosetta_test_model_Bar(com_rosetta_test_model_Foo):
            a: Optional[str] = Field(None, description='')'''
        
        assertTrue(_bundle.contains(expectedFoo), "\nexpectedFoo" + expectedFoo + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedBar), "\nexpectedBar" + expectedBar + "\n_bundle\n" + _bundle)
    }

    @Test
    def testGenerateRosettaCalculationTypeAsString() {
        val python = testUtils.generatePythonFromString('''
            type Foo:
                bar calculation (0..1)
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expected =
        '''
        class com_rosetta_test_model_Foo(BaseDataClass):
            bar: Optional[str] = Field(None, description='')'''
        
        assertTrue(_bundle.contains(expected), "expected\n" + expected + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testSetAttributesOnEmptyClassWithInheritance() {
        val python = testUtils.generatePythonFromString('''
            type Foo:
                attr string (0..1)
            
            type Bar extends Foo:
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expectedFoo=
        '''
        class com_rosetta_test_model_Foo(BaseDataClass):
            attr: Optional[str] = Field(None, description='')'''

        val expectedBar=
        '''
        class com_rosetta_test_model_Bar(com_rosetta_test_model_Foo):
            pass'''
        
        assertTrue(_bundle.contains(expectedFoo), "expectedFoo\n" + expectedFoo + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedBar), "expectedBar\n" + expectedBar + "\n_bundle\n" + _bundle)
    }
    

    @Test
    def void testConditions1() {
        val python = testUtils.generatePythonFromString('''
            type A:
                a0 int (0..1)
                a1 int (0..1)
                condition: one-of
            
            type B:
                intValue1 int (0..1)
                intValue2 int (0..1)
                aValue A (1..1)
                
                condition Rule:
                    intValue1 < 100
                
                condition OneOrTwo: <"Choice rule to represent an FpML choice construct.">
                    optional choice intValue1, intValue2
                
                condition SecondOneOrTwo: <"FpML specifies a choice between adjustedDate and [unadjustedDate (required), dateAdjutsments (required), adjustedDate (optional)].">
                    aValue->a0 exists
                        or (intValue2 exists and intValue1 exists and intValue1 exists)
                        or (intValue2 exists and intValue1 exists and intValue1 is absent)
            ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expectedA = '''
        class com_rosetta_test_model_A(BaseDataClass):
            a0: Optional[int] = Field(None, description='')
            a1: Optional[int] = Field(None, description='')
            
            @rune_condition
            def condition_0_(self):
                item = self
                return rune_check_one_of(self, 'a0', 'a1', necessity=True)'''
        val expectedB = '''
        class com_rosetta_test_model_B(BaseDataClass):
            intValue1: Optional[int] = Field(None, description='')
            intValue2: Optional[int] = Field(None, description='')
            aValue: Annotated[com_rosetta_test_model_A, com_rosetta_test_model_A.serializer(), com_rosetta_test_model_A.validator()] = Field(..., description='')
            
            @rune_condition
            def condition_0_Rule(self):
                item = self
                return rune_all_elements(rune_resolve_attr(self, "intValue1"), "<", 100)
            
            @rune_condition
            def condition_1_OneOrTwo(self):
                """
                Choice rule to represent an FpML choice construct.
                """
                item = self
                return rune_check_one_of(self, 'intValue1', 'intValue2', necessity=False)
            
            @rune_condition
            def condition_2_SecondOneOrTwo(self):
                """
                FpML specifies a choice between adjustedDate and [unadjustedDate (required), dateAdjutsments (required), adjustedDate (optional)].
                """
                item = self
                return ((rune_attr_exists(rune_resolve_attr(rune_resolve_attr(self, "aValue"), "a0")) or ((rune_attr_exists(rune_resolve_attr(self, "intValue2")) and rune_attr_exists(rune_resolve_attr(self, "intValue1"))) and rune_attr_exists(rune_resolve_attr(self, "intValue1")))) or ((rune_attr_exists(rune_resolve_attr(self, "intValue2")) and rune_attr_exists(rune_resolve_attr(self, "intValue1"))) and (not rune_attr_exists(rune_resolve_attr(self, "intValue1")))))'''

        assertTrue(_bundle.contains(expectedA), "expectedA\n" + expectedA + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedB), "expectedB\n" + expectedB + "\n_bundle\n" + _bundle)
    }
    
    @Test
    def void testGenerateTypes() {
        val python = testUtils.generatePythonFromString('''
        type TestType: <"Test type description.">
            testTypeValue1 string (1..1) <"Test string">
            testTypeValue2 string (0..1) <"Test optional string">
            testTypeValue3 string (1..*) <"Test string list">
            testTypeValue4 TestType2 (1..1) <"Test TestType2">
            testEnum TestEnum (0..1) <"Optional test enum">

        type TestType2:
            testType2Value1 number(1..*) <"Test number list">
            testType2Value2 date(0..1) <"Test date">
            testEnum TestEnum (0..1) <"Optional test enum">

        enum TestEnum: <"Test enum description.">
            TestEnumValue1 <"Test enum value 1">
            TestEnumValue2 <"Test enum value 2">
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()

        val expectedTestType=
        '''
        class com_rosetta_test_model_TestType(BaseDataClass):
            """
            Test type description.
            """
            testTypeValue1: str = Field(..., description='Test string')
            """
            Test string
            """
            testTypeValue2: Optional[str] = Field(None, description='Test optional string')
            """
            Test optional string
            """
            testTypeValue3: list[str] = Field([], description='Test string list', min_length=1)
            """
            Test string list
            """
            testTypeValue4: Annotated[com_rosetta_test_model_TestType2, com_rosetta_test_model_TestType2.serializer(), com_rosetta_test_model_TestType2.validator()] = Field(..., description='Test TestType2')
            """
            Test TestType2
            """
            testEnum: Optional[com.rosetta.test.model.TestEnum.TestEnum] = Field(None, description='Optional test enum')
            """
            Optional test enum
            """'''
        val expectedTestType2=
        '''
        class com_rosetta_test_model_TestType2(BaseDataClass):
            testType2Value1: list[Decimal] = Field([], description='Test number list', min_length=1)
            """
            Test number list
            """
            testType2Value2: Optional[datetime.date] = Field(None, description='Test date')
            """
            Test date
            """
            testEnum: Optional[com.rosetta.test.model.TestEnum.TestEnum] = Field(None, description='Optional test enum')
            """
            Optional test enum
            """'''
        assertTrue(_bundle.contains(expectedTestType), "expectedTestType\n" + expectedTestType + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedTestType2), "expectedTestType\n" + expectedTestType2 + "\n_bundle\n" + _bundle)
    }        
    
    @Test
    def void testGenerateTypesMethod2() {
        val python = testUtils.generatePythonFromString('''
        type UnitType: <"Defines the unit to be used for price, quantity, or other purposes">
            currency string (0..1) <"Defines the currency to be used as a unit for a price, quantity, or other purpose.">

        type MeasureBase: <"Provides an abstract base class shared by Price and Quantity.">
            amount number (1..1) <"Specifies an amount to be qualified and used in a Price or Quantity definition.">
            unitOfAmount UnitType (1..1) <"Qualifies the unit by which the amount is measured.">

        type Quantity extends MeasureBase: <"Specifies a quantity to be associated to a financial product, for example a trade amount or a cashflow amount resulting from a trade.">
            multiplier number (0..1) <"Defines the number to be multiplied by the amount to derive a total quantity.">
            multiplierUnit UnitType (0..1) <"Qualifies the multiplier with the applicable unit.  For example in the case of the Coal (API2) CIF ARA (ARGUS-McCloskey) Futures Contract on the CME, where the unitOfAmount would be contracts, the multiplier would 1,000 and the mulitiplier Unit would be 1,000 MT (Metric Tons).">
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()

        val expectedMeasureBase =
        '''
        class com_rosetta_test_model_MeasureBase(BaseDataClass):
            """
            Provides an abstract base class shared by Price and Quantity.
            """
            amount: Decimal = Field(..., description='Specifies an amount to be qualified and used in a Price or Quantity definition.')
            """
            Specifies an amount to be qualified and used in a Price or Quantity definition.
            """
            unitOfAmount: Annotated[com_rosetta_test_model_UnitType, com_rosetta_test_model_UnitType.serializer(), com_rosetta_test_model_UnitType.validator()] = Field(..., description='Qualifies the unit by which the amount is measured.')
            """
            Qualifies the unit by which the amount is measured.
            """'''
        
        val expectedUnitType =
        '''
        class com_rosetta_test_model_UnitType(BaseDataClass):
            """
            Defines the unit to be used for price, quantity, or other purposes
            """
            currency: Optional[str] = Field(None, description='Defines the currency to be used as a unit for a price, quantity, or other purpose.')
            """
            Defines the currency to be used as a unit for a price, quantity, or other purpose.
            """'''
        
        val expectedQuantity =
        '''
        class com_rosetta_test_model_Quantity(com_rosetta_test_model_MeasureBase):
            """
            Specifies a quantity to be associated to a financial product, for example a trade amount or a cashflow amount resulting from a trade.
            """
            multiplier: Optional[Decimal] = Field(None, description='Defines the number to be multiplied by the amount to derive a total quantity.')
            """
            Defines the number to be multiplied by the amount to derive a total quantity.
            """
            multiplierUnit: Optional[Annotated[com_rosetta_test_model_UnitType, com_rosetta_test_model_UnitType.serializer(), com_rosetta_test_model_UnitType.validator()]] = Field(None, description='Qualifies the multiplier with the applicable unit. For example in the case of the Coal (API2) CIF ARA (ARGUS-McCloskey) Futures Contract on the CME, where the unitOfAmount would be contracts, the multiplier would 1,000 and the mulitiplier Unit would be 1,000 MT (Metric Tons).')
            """
            Qualifies the multiplier with the applicable unit.  For example in the case of the Coal (API2) CIF ARA (ARGUS-McCloskey) Futures Contract on the CME, where the unitOfAmount would be contracts, the multiplier would 1,000 and the mulitiplier Unit would be 1,000 MT (Metric Tons).
            """'''
        assertTrue(_bundle.contains(expectedMeasureBase), "expected\n" + expectedMeasureBase + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedUnitType), "expected\n" + expectedUnitType + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedQuantity), "expected\n" + expectedQuantity + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testGenerateTypesExtends() {
        val python = testUtils.generatePythonFromString('''
        type TestType extends TestType2:
            TestTypeValue1 string (1..1) <"Test string">
            TestTypeValue2 int (0..1) <"Test int">

        type TestType2 extends TestType3:
            TestType2Value1 number (0..1) <"Test number">
            TestType2Value2 date (1..*) <"Test date">

        type TestType3:
            TestType3Value1 string (0..1) <"Test string">
            TestType4Value2 int (1..*) <"Test int">
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
       
        val expectedTestType = 
        '''
        class com_rosetta_test_model_TestType(com_rosetta_test_model_TestType2):
            TestTypeValue1: str = Field(..., description='Test string')
            """
            Test string
            """
            TestTypeValue2: Optional[int] = Field(None, description='Test int')
            """
            Test int
            """'''
        val expectedTestType2 =
        '''
        class com_rosetta_test_model_TestType2(com_rosetta_test_model_TestType3):
            TestType2Value1: Optional[Decimal] = Field(None, description='Test number')
            """
            Test number
            """
            TestType2Value2: list[datetime.date] = Field([], description='Test date', min_length=1)
            """
            Test date
            """'''
        val expectedTestType3 = 
        '''
        class com_rosetta_test_model_TestType3(BaseDataClass):
            TestType3Value1: Optional[str] = Field(None, description='Test string')
            """
            Test string
            """
            TestType4Value2: list[int] = Field([], description='Test int', min_length=1)
            """
            Test int
            """'''
        
        assertTrue(_bundle.contains(expectedTestType), "expectedTestType\n" + expectedTestType + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedTestType2), "expectedTestType2\n" + expectedTestType2 + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedTestType3), "expectedTestType3\n" + expectedTestType3 + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testGenerateTypesChoiceCondition() {
        val python = testUtils.generatePythonFromString('''type TestType: <"Test type with one-of condition.">
            field1 string (0..1) <"Test string field 1">
            field2 string (0..1) <"Test string field 2">
            field3 number (0..1) <"Test number field 3">
            field4 number (1..*) <"Test number field 4">
            condition BusinessCentersChoice: <"Choice rule to represent an FpML choice construct.">
                    required choice field1, field2
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expected =
        '''
        class com_rosetta_test_model_TestType(BaseDataClass):
            """
            Test type with one-of condition.
            """
            field1: Optional[str] = Field(None, description='Test string field 1')
            """
            Test string field 1
            """
            field2: Optional[str] = Field(None, description='Test string field 2')
            """
            Test string field 2
            """
            field3: Optional[Decimal] = Field(None, description='Test number field 3')
            """
            Test number field 3
            """
            field4: list[Decimal] = Field([], description='Test number field 4', min_length=1)
            """
            Test number field 4
            """
            
            @rune_condition
            def condition_0_BusinessCentersChoice(self):
                """
                Choice rule to represent an FpML choice construct.
                """
                item = self
                return rune_check_one_of(self, 'field1', 'field2', necessity=True)'''
        assertTrue(_bundle.contains(expected), "expected\n" + expected + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testGenerateIfThenCondition() {
        val python = testUtils.generatePythonFromString('''type TestType: <"Test type with one-of condition.">
            field1 string (0..1) <"Test string field 1">
            field2 string (0..1) <"Test string field 2">
            field3 number (0..1) <"Test number field 3">
            field4 number (1..*) <"Test number field 4">
            condition BusinessCentersChoice: <"Choice rule to represent an FpML choice construct.">
                    if field1 exists
                            then field3 > 0
        ''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expected = 
        '''
        class com_rosetta_test_model_TestType(BaseDataClass):
            """
            Test type with one-of condition.
            """
            field1: Optional[str] = Field(None, description='Test string field 1')
            """
            Test string field 1
            """
            field2: Optional[str] = Field(None, description='Test string field 2')
            """
            Test string field 2
            """
            field3: Optional[Decimal] = Field(None, description='Test number field 3')
            """
            Test number field 3
            """
            field4: list[Decimal] = Field([], description='Test number field 4', min_length=1)
            """
            Test number field 4
            """
            
            @rune_condition
            def condition_0_BusinessCentersChoice(self):
                """
                Choice rule to represent an FpML choice construct.
                """
                item = self
                def _then_fn0():
                    return rune_all_elements(rune_resolve_attr(self, "field3"), ">", 0)
                
                def _else_fn0():
                    return True
                
                return if_cond_fn(rune_attr_exists(rune_resolve_attr(self, "field1")), _then_fn0, _else_fn0)'''
            assertTrue(_bundle.contains(expected), "expected\n" + expected + "\n_bundle\n" + _bundle)
    }

    @Test
    def void testConditionsGeneration() {
        val python = testUtils.generatePythonFromString('''type A:
            a0 int (0..1)
            a1 int (0..1)
            condition: one-of
        type B:
            intValue1 int (0..1)
            intValue2 int (0..1)
            aValue A (1..1)
            condition Rule:
                intValue1 < 100
            condition OneOrTwo: <"Choice rule to represent an FpML choice construct.">
                optional choice intValue1, intValue2
            condition ReqOneOrTwo: <"Choice rule to represent an FpML choice construct.">
                required choice intValue1, intValue2
            condition SecondOneOrTwo: <"FpML specifies a choice between adjustedDate and [unadjustedDate (required), dateAdjutsments (required), adjustedDate (optional)].">
                aValue->a0 exists
                    or (intValue2 exists and intValue1 exists and intValue1 exists)
                    or (intValue2 exists and intValue1 exists and intValue1 is absent)''')
        val _bundle = python.get("src/com/_bundle.py").toString()
        val expectedA = 
        '''
        class com_rosetta_test_model_A(BaseDataClass):
            a0: Optional[int] = Field(None, description='')
            a1: Optional[int] = Field(None, description='')
            
            @rune_condition
            def condition_0_(self):
                item = self
                return rune_check_one_of(self, 'a0', 'a1', necessity=True)'''
                
        val expectedB = 
        '''
        class com_rosetta_test_model_B(BaseDataClass):
            intValue1: Optional[int] = Field(None, description='')
            intValue2: Optional[int] = Field(None, description='')
            aValue: Annotated[com_rosetta_test_model_A, com_rosetta_test_model_A.serializer(), com_rosetta_test_model_A.validator()] = Field(..., description='')
            
            @rune_condition
            def condition_0_Rule(self):
                item = self
                return rune_all_elements(rune_resolve_attr(self, "intValue1"), "<", 100)
            
            @rune_condition
            def condition_1_OneOrTwo(self):
                """
                Choice rule to represent an FpML choice construct.
                """
                item = self
                return rune_check_one_of(self, 'intValue1', 'intValue2', necessity=False)
            
            @rune_condition
            def condition_2_ReqOneOrTwo(self):
                """
                Choice rule to represent an FpML choice construct.
                """
                item = self
                return rune_check_one_of(self, 'intValue1', 'intValue2', necessity=True)
            
            @rune_condition
            def condition_3_SecondOneOrTwo(self):
                """
                FpML specifies a choice between adjustedDate and [unadjustedDate (required), dateAdjutsments (required), adjustedDate (optional)].
                """
                item = self
                return ((rune_attr_exists(rune_resolve_attr(rune_resolve_attr(self, "aValue"), "a0")) or ((rune_attr_exists(rune_resolve_attr(self, "intValue2")) and rune_attr_exists(rune_resolve_attr(self, "intValue1"))) and rune_attr_exists(rune_resolve_attr(self, "intValue1")))) or ((rune_attr_exists(rune_resolve_attr(self, "intValue2")) and rune_attr_exists(rune_resolve_attr(self, "intValue1"))) and (not rune_attr_exists(rune_resolve_attr(self, "intValue1")))))'''

        assertTrue(_bundle.contains(expectedA), "expectedA\n" + expectedA + "\n_bundle\n" + _bundle)
        assertTrue(_bundle.contains(expectedB), "expectedB\n" + expectedB + "\n_bundle\n" + _bundle)
    }
}