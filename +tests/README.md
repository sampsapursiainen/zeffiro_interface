# +tests/

This test package contains the tests of Zeffiro Interface. All test class file
names end in the case-insensitive string `test`. To run all of them at once,
navigate to the project root and type

	runtests tests

in the Matlab console to run all of the test cases in this test package
folder. You can also run individual test cases by explicitly instantiating
them and calling their `run`-methods:

	lead_field_tests = tests.LeadFieldTest;

	results = lead_field_tests.run();

Even individual tests within a test case can be called by calling the
individual test methods:

	lead_field_tests = tests.LeadFieldTest;

	results = lead_field_tests.ary_model_comparison();

See the [Matlab documentation on class-based testing][cbt] to see how they
work in detail. Most notably, each test class name and their corresponding
file names must end in the string `Test`.

[cbt]: https://se.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
