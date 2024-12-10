# _Build and testing instruction_

1. Generate CDM from Rosetta / Rune
- Update the attribute <cdm.rosetta.source.path> in python/pom.xml to point to the Rune/Rosetta files
- In PythonFilesGeneratorTest.xtend, comment the line "@Disabled("Generate CDM from Rosetta Files") (immediately before `def void generateCDMPythonFromRosetta`)
- Run the build and execute the Java Unit Test

##
        bash mvn clean install

2. Rebuild the runtime package

##
        bash src/main/resources/build_runtime.sh

3. Build the CDM package
##
        bash build/build_cdm.sh

4. Run the core Python Unit tests

##
        bash test/run_tests.sh

5. Test whether the generated code can read and validate a CDM JSON file

##
        bash test/cdm_tests/run_serialization_test.sh
