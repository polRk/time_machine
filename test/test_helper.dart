import 'dart:async';
import 'dart:math' as math;

import 'dart:mirrors';
import 'package:time_machine/time_machine.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart';
import 'package:time_machine/time_machine_timezones.dart';

import 'test_fx.dart';
import 'time_matchers.dart';

/// <summary>
/// Provides methods to help run tests for some of the system interfaces and object support.
/// </summary>
abstract class TestHelper
{
  // static readonly bool IsRunningOnMono = Type.GetType("Mono.Runtime") != null;

  /// <summary>
  /// Does nothing other than let us prove method or constructor calls don't throw.
  /// </summary>
  static void Consume<T>(T ignored)
  {
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified value throws ArgumentException.
  /// </summary>
  static void AssertInvalid<TArg, TOut>(TOut func(TArg), TArg arg)
  {
    expect(() => func(arg), throwsArgumentError);
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified values throws ArgumentException.
  /// </summary>
  static void AssertInvalid2<TArg1, TArg2, TOut>(TOut func(TArg1, TArg2), TArg1 arg1, TArg2 arg2)
  {
    // Assert.Throws<ArgumentException>(() => func(arg1, arg2));
    expect(() => func(arg1, arg2), throwsArgumentError);
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified value throws ArgumentNullException.
  /// </summary>
  static void AssertArgumentNull<TArg, TOut>(TOut func(TArg), TArg arg)
  {
    expect(() => func(arg), throwsNullThrownError);
    // Assert.Throws<ArgumentNullException>(() => func(arg));
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified value throws ArgumentOutOfRangeException.
  /// </summary>
  static void AssertOutOfRange<TArg, TOut>(TOut func(TArg), TArg arg)
  {
    expect(() => func(arg), throwsRangeError);
    // Assert.Throws<ArgumentOutOfRangeException>(() => func(arg));
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified value doesn't throw an exception.
  /// </summary>
  static void AssertValid<TArg, TOut>(TOut func(TArg), TArg arg)
  {
    func(arg);
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified values throws ArgumentOutOfRangeException.
  /// </summary>
  static void AssertOutOfRange2<TArg1, TArg2, TOut>(TOut func(TArg1, TArg2), TArg1 arg1, TArg2 arg2)
  {
    // Assert.Throws<ArgumentOutOfRangeException>(() => func(arg1, arg2));
    expect(func(arg1, arg2), throwsRangeError);
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified values throws ArgumentNullException.
  /// </summary>
  static void AssertArgumentNull2<TArg1, TArg2, TOut>(TOut func(TArg1, TArg2), TArg1 arg1, TArg2 arg2)
  {
    // Assert.Throws<ArgumentNullException>(() => func(arg1, arg2));
    expect(func(arg1, arg2), throwsNullThrownError);
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified values doesn't throw an exception.
  /// </summary>
  static void AssertValid2<TArg1, TArg2, TOut>(TOut func(TArg1, TArg2), TArg1 arg1, TArg2 arg2)
  {
    func(arg1, arg2);
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified values throws ArgumentOutOfRangeException.
  /// </summary>
  static void AssertOutOfRange3<TArg1, TArg2, TArg3, TOut>(TOut func(TArg1, TArg2, TArg3), TArg1 arg1, TArg2 arg2, TArg3 arg3)
  {
    // Assert.Throws<ArgumentOutOfRangeException>(() => func(arg1, arg2, arg3));
    expect(func(arg1, arg2, arg3), throwsRangeError);
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified values throws ArgumentNullException.
  /// </summary>
  static void AssertArgumentNull3<TArg1, TArg2, TArg3, TOut>(TOut func(TArg1, TArg2, TArg3), TArg1 arg1, TArg2 arg2, TArg3 arg3)
  {
    // Assert.Throws<ArgumentNullException>(() => func(arg1, arg2, arg3));
    expect(func(arg1, arg2, arg3), throwsNullThrownError);
  }

  /// <summary>
  /// Asserts that calling the specified delegate with the specified values doesn't throw an exception.
  /// </summary>
  static void AssertValid3<TArg1, TArg2, TArg3, TOut>(TOut func(TArg1, TArg2, TArg3), TArg1 arg1, TArg2 arg2, TArg3 arg3)
  {
    func(arg1, arg2, arg3);
  }

  /// <summary>
  /// Asserts that the given operation throws one of InvalidOperationException, ArgumentException (including
  /// ArgumentOutOfRangeException) or OverflowException. (It's hard to always be consistent bearing in mind
  /// one method calling another.)
  /// </summary>
  static void AssertOverflow<TArg1, TOut>(TOut func(TArg1), TArg1 arg1)
  {
    AssertOverflow_Action(() => func(arg1));
  }

  /// <summary>
  /// Typically used to report a list of items (e.g. reflection members) that fail a condition, one per line.
  /// </summary>
  static void AssertNoFailures<T>(Iterable<T> failures, String failureFormatter(T))
  {
    var failureList = failures.toList();
    if (failureList.isEmpty)
    {
      return;
    }
    var message = "Failures: ${failureList.length}\n${failureList.map((i) => failureFormatter(i))}";
    throw new Exception(message);
  }

//  static void AssertNoFailures<T>(Iterable<T> failures, String failureFormatter(T), TestExemptionCategory category)
//  // where T : MemberInfo
//  => AssertNoFailures(failures.where(member => !IsExempt(member, category)), failureFormatter);

//  static bool IsExempt(MemberInfo member, TestExemptionCategory category) =>
//      member.GetCustomAttributes(typeof(TestExemptionAttribute), false)
//          .Cast<TestExemptionAttribute>()
//          .Any(e => e.Category == category);

  /// <summary>
  /// Asserts that the given operation throws one of InvalidOperationException, ArgumentException (including
  /// ArgumentOutOfRangeException) or OverflowException. (It's hard to always be consistent bearing in mind
  /// one method calling another.)
  /// </summary>
  static void AssertOverflow_Action(action())
  {
    try
    {
      action();
      throw new Exception("Expected OverflowException, ArgumentException, ArgumentOutOfRangeException or InvalidOperationException");
    }
    // todo: we don't really overflow
//    on OverflowException catch (e)
//    {
//    }
    on ArgumentError catch (e)
    {
      //Assert.IsTrue(e.GetType() == typeof(ArgumentException) || e.GetType() == typeof(ArgumentOutOfRangeException),
      //"Exception should not be a subtype of ArgumentException, other than ArgumentOutOfRangeException");
    }
    catch (InvalidOperationException)
    {
    }
  }

  static void TestComparerStruct2<T>(Comparable<T> comparer, T value, T equalValue, T greaterValue) // where T : struct
  {
    Comparable.compare(a, b);
    expect(comparer.Compare(value, equalValue), 0);
    expect(comparer.Compare(greaterValue, value).sign, 1);
    expect(comparer.Compare(value, greaterValue).sign, -1);

    //Assert.AreEqual(0, comparer.Compare(value, equalValue));
    //Assert.AreEqual(1, math.Sign(comparer.Compare(greaterValue, value)));
    //Assert.AreEqual(-1, Math.Sign(comparer.Compare(value, greaterValue)));
  }

  static void TestComparerStruct<T>(Comparator<T> comparer, T value, T equalValue, T greaterValue)
  {
    expect(comparer(value, equalValue), 0);
    expect(comparer(greaterValue, value).sign, 1);
    expect(comparer(value, greaterValue).sign, -1);

    //Assert.AreEqual(0, comparer.Compare(value, equalValue));
    //Assert.AreEqual(1, math.Sign(comparer.Compare(greaterValue, value)));
    //Assert.AreEqual(-1, Math.Sign(comparer.Compare(value, greaterValue)));
  }


  /// <summary>
  ///   Tests the <see cref="IComparable{T}.CompareTo" /> method for reference objects.
  /// </summary>
  /// <typeparam name="T">The type to test.</typeparam>
  /// <param name="value">The base value.</param>
  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
  /// <param name="greaterValue">The values greater than the base value, in ascending order.</param>
  static void TestCompareToClass<T extends Comparable<T>>(T value, T equalValue, List<T> greaterValues)
  {
    ValidateInput(value, equalValue, greaterValues, "greaterValue");
    expect(value.compareTo(null) > 0, isTrue, reason: "value.CompareTo<T>(null)");
    expect(value.compareTo(value) == 0, isTrue, reason: "value.CompareTo<T>(value)");
    expect(value.compareTo(equalValue) == 0, isTrue, reason: "value.CompareTo<T>(equalValue)");
    expect(equalValue.compareTo(value) == 0, isTrue, reason: "equalValue.CompareTo<T>(value)");
    for (var greaterValue in greaterValues) {
      expect(value.compareTo(greaterValue) < 0, isTrue, reason: "value.CompareTo<T>(greaterValue)");
      expect(greaterValue.compareTo(value) > 0, isTrue, reason: "greaterValue.CompareTo<T>(value)");
      // Now move up to the next pair...
      value = greaterValue;
    }
  }

  /// <summary>
  /// Tests the <see cref="IComparable{T}.CompareTo" /> method for value objects.
  /// </summary>
  /// <typeparam name="T">The type to test.</typeparam>
  /// <param name="value">The base value.</param>
  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
  /// <param name="greaterValue">The values greater than the base value, in ascending order.</param>
  static void TestCompareToStruct<T extends Comparable<T>>(T value, T equalValue, List<T> greaterValues) // where T : struct, IComparable<T>
  {
    TestCompareToClass<T>(value, equalValue, greaterValues);
//    Assert.AreEqual(value.CompareTo(value), 0, "value.CompareTo(value)");
//    Assert.AreEqual(value.CompareTo(equalValue), 0, "value.CompareTo(equalValue)");
//    Assert.AreEqual(equalValue.CompareTo(value), 0, "equalValue.CompareTo(value)");
//    for (var greaterValue in greaterValues) {
//      Assert.Less(value.CompareTo(greaterValue), 0, "value.CompareTo(greaterValue)");
//      Assert.Greater(greaterValue.CompareTo(value), 0, "greaterValue.CompareTo(value)");
//      // Now move up to the next pair...
//      value = greaterValue;
//    }
  }

//  /// <summary>
//  /// Tests the <see cref="IComparable.CompareTo" /> method - note that this is the non-generic interface.
//  /// </summary>
//  /// <typeparam name="T">The type to test.</typeparam>
//  /// <param name="value">The base value.</param>
//  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
//  /// <param name="greaterValue">The values greater than the base value, in ascending order.</param>
//  static void TestNonGenericCompareTo<T>(T value, T equalValue, List<T> greaterValues) // where T : IComparable
//  {
//  // Just type the values as plain IComparable for simplicity
//  IComparable value2 = value;
//  IComparable equalValue2 = equalValue;
//
//  ValidateInput(value2, equalValue2, greaterValues, "greaterValues");
//  Assert.Greater(value2.CompareTo(null), 0, "value.CompareTo(null)");
//  Assert.AreEqual(value2.CompareTo(value2), 0, "value.CompareTo(value)");
//  Assert.AreEqual(value2.CompareTo(equalValue2), 0, "value.CompareTo(equalValue)");
//  Assert.AreEqual(equalValue2.CompareTo(value2), 0, "equalValue.CompareTo(value)");
//
//  for (IComparable greaterValue in greaterValues)
//  {
//  Assert.Less(value2.CompareTo(greaterValue), 0, "value.CompareTo(greaterValue)");
//  Assert.Greater(greaterValue.CompareTo(value2), 0, "greaterValue.CompareTo(value)");
//  // Now move up to the next pair...
//  value2 = greaterValue;
//  }
//  Assert.Throws<ArgumentException>(() => value2.CompareTo(new object()));
//  }

  /// <summary>
  /// Tests the IEquatable.Equals method for reference objects. Also tests the
  /// object equals method.
  /// </summary>
  /// <typeparam name="T">The type to test.</typeparam>
  /// <param name="value">The base value.</param>
  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
  /// <param name="unequalValue">Values not equal to the base value.</param>
  static void TestEqualsClass<T>(T value, T equalValue, List<T> unequalValues) // where T : class, IEquatable<T>
  {
    TestObjectEquals(value, equalValue, unequalValues);
    expect(value == (null), isFalse, reason: "value.Equals<T>(null)");
    expect(value == (value), isTrue, reason: "value.Equals<T>(value)");
    expect(value == (equalValue), isTrue, reason: "value.Equals<T>(equalValue)");
    expect(equalValue == (value), isTrue, reason: "equalValue.Equals<T>(value)");
    for (var unequal in unequalValues) {
      expect(value == (unequal), isFalse, reason: "value.Equals<T>(unequalValue)");
    }
  }

  /// <summary>
  /// Tests the IEquatable.Equals method for value objects. Also tests the
  /// object equals method.
  /// </summary>
  /// <typeparam name="T">The type to test.</typeparam>
  /// <param name="value">The base value.</param>
  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
  /// <param name="unequalValue">The value not equal to the base value.</param>
  static void TestEqualsStruct<T>(T value, T equalValue, Iterable<T> unequalValues) // where T : struct, IEquatable<T>
  {
    // var unequalArray = unequalValues.toList(); // unequalValues.Cast<object>().ToArray();
    TestEqualsClass(value, equalValue, unequalValues.toList());
//    TestObjectEquals(value, equalValue, unequalArray);
//    Assert.True(value == (value), reason: "value.Equals<T>(value)");
//    Assert.True(value == (equalValue), reason: "value.Equals<T>(equalValue)");
//    Assert.True(equalValue == (value), reason: "equalValue.Equals<T>(value)");
//    for (var unequalValue in unequalValues) {
//      Assert.False(value == (unequalValue), reason: "value.Equals<T>(unequalValue)");
//    }
  }

  /// <summary>
  /// Tests the Object.Equals method.
  /// </summary>
  /// <remarks>
  /// It takes two equal values, and then an array of values which should not be equal to the first argument.
  /// </remarks>
  /// <param name="value">The base value.</param>
  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
  /// <param name="unequalValue">The value not equal to the base value.</param>
  static void TestObjectEquals(Object value, Object equalValue, List<Object> unequalValues) {
    ValidateInput(value, equalValue, unequalValues, "unequalValue");
    expect(value == null, isFalse, reason: "value.Equals(null)");
    expect(value == (value), isTrue, reason: "value.Equals(value)");
    expect(value == (equalValue), isTrue, reason: "value.Equals(equalValue)");
    expect(equalValue == (value), isTrue, reason: "equalValue.Equals(value)");
    for (var unequalValue in unequalValues) {
      expect(value == (unequalValue), isFalse, reason: "value.Equals(unequalValue)");
    }
    expect(value.hashCode, value.hashCode, reason: "hashCode twice for same object");
    expect(value.hashCode, equalValue.hashCode, reason: "hashCode for two different but equal objects");
  }

  /// <summary>
  /// Tests the less than (&lt;) and greater than (&gt;) operators if they exist on the object.
  /// </summary>
  /// <typeparam name="T">The type to test.</typeparam>
  /// <param name="value">The base value.</param>
  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
  /// <param name="greaterValue">The values greater than the base value, in ascending order.</param>
  static void TestOperatorComparison<T>(T value, T equalValue, List<T> greaterValues) {
    ValidateInput(value, equalValue, greaterValues, "greaterValue");

    // Note: Dart is doing type erasure??? -- T becomes dynamic at runtime when it shouldn't be.
    // todo: re-evaluate after Dart 2.0
    InstanceMirror valueMirror = reflect(value);
    InstanceMirror equalValueMirror = reflect(equalValue);
    ClassMirror classMirror = reflectClass(/*T*/value.runtimeType);

    var gt = new Symbol(">");
    var lt = new Symbol("<");
    var greaterThan = classMirror.declarations[gt];
    var lessThan = classMirror.declarations[lt];

    // print(instanceMirror.invoke(gt.simpleName, [null]).reflectee);
    // print(instanceMirror.invoke(lt.simpleName, [null]).reflectee);

    // Comparisons only involving equal values
    if (greaterThan != null) {
      // if (!type.GetTypeInfo().IsValueType)
      {
        expect(valueMirror.invoke(gt, [null]).reflectee, isTrue, reason: "value > null");
        // expect(greaterThan.Invoke(null, [ null, value ], isFalse, reason: "null > value");
      }
      expect(valueMirror.invoke(gt, [value]).reflectee, isFalse, reason: "value > value");
      expect(valueMirror.invoke(gt, [equalValue]).reflectee, isFalse, reason: "value > equalValue");
      expect(equalValueMirror.invoke(gt, [value]).reflectee, isFalse, reason: "equalValue > value");
    }
    if (lessThan != null) {
      // if (!type.GetTypeInfo().IsValueType)
      {
        expect(valueMirror.invoke(lt, [null]).reflectee, isFalse, reason: "value < null");
        // expect(lessThan.Invoke(null, [ null, value ], isTrue, reason: "null < value");
      }
      expect(valueMirror.invoke(lt, [value]).reflectee, isFalse, reason: "value > value");
      expect(valueMirror.invoke(lt, [equalValue]).reflectee, isFalse, reason: "value > equalValue");
      expect(equalValueMirror.invoke(lt, [value]).reflectee, isFalse, reason: "equalValue > value");
    }

    // Then comparisons involving the greater values
    for (var greaterValue in greaterValues) {
      InstanceMirror greaterValueMirror = reflect(greaterValue);
      if (greaterThan != null) {
        expect(valueMirror.invoke(gt, [greaterValue]).reflectee, isFalse, reason: "value > greaterValue");
        expect(greaterValueMirror.invoke(gt, [value]).reflectee, isTrue, reason: "greaterValue > value");
      }
      if (lessThan != null) {
        expect(valueMirror.invoke(lt, [greaterValue]).reflectee, isTrue, reason: "value < greaterValue");
        expect(greaterValueMirror.invoke(lt, [value]).reflectee, isFalse, reason: "greaterValue < value");
      }
      // Now move up to the next pair...
      value = greaterValue;
    }
  }

  /// <summary>
  /// Tests the equality (==), inequality (!=), less than (&lt;), greater than (&gt;), less than or equals (&lt;=),
  /// and greater than or equals (&gt;=) operators if they exist on the object.
  /// </summary>
  /// <typeparam name="T">The type to test.</typeparam>
  /// <param name="value">The base value.</param>
  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
  /// <param name="greaterValue">The values greater than the base value, in ascending order.</param>
  static void TestOperatorComparisonEquality<T>(T value, T equalValue, List<T> greaterValues) {
    for (var greaterValue in greaterValues) {
      TestOperatorEquality<T>(value, equalValue, greaterValue);
    }
    TestOperatorComparison<T>(value, equalValue, greaterValues);

    InstanceMirror valueMirror = reflect(value);
    InstanceMirror equalValueMirror = reflect(equalValue);
    ClassMirror classMirror = reflectClass(/*T*/value.runtimeType);

    var gte = new Symbol(">=");
    var lte = new Symbol("<=");
    var greaterThanOrEqual = classMirror.declarations[gte];
    var lessThanOrEqual = classMirror.declarations[lte];

    // First the comparisons with equal values
    if (greaterThanOrEqual != null) {
      //if (!type.GetTypeInfo().IsValueType)
      {
        expect(valueMirror.invoke(gte, [null]).reflectee, isTrue, reason: "value >= null");
        // expect(valueMirror.invoke(gte, [value]), greaterThanOrEqual.Invoke(null, [ null, value ], isFalse, reason: "null >= value");
      }
      expect(valueMirror.invoke(gte, [value]).reflectee, isTrue, reason: "value >= value");
      expect(valueMirror.invoke(gte, [equalValue]).reflectee, isTrue, reason: "value >= equalValue");
      expect(equalValueMirror.invoke(gte, [value]).reflectee, isTrue, reason: "equalValue >= value");
    }
    if (lessThanOrEqual != null) {
      //if (!type.GetTypeInfo().IsValueType)
      {
        expect(valueMirror.invoke(lte, [null]).reflectee, isFalse, reason: "value <= null");
        // expect(lessThanOrEqual.Invoke(null, [ null, value ], isTrue, reason: "null <= value");
      }
      expect(valueMirror.invoke(lte, [value]).reflectee, isTrue, reason: "value <= value");
      expect(valueMirror.invoke(lte, [equalValue]).reflectee, isTrue, reason: "value <= equalValue");
      expect(equalValueMirror.invoke(lte, [value]).reflectee, isTrue, reason: "equalValue <= value");
    }

    // Now the "greater than" values
    for (var greaterValue in greaterValues) {
      InstanceMirror greaterValueMirror = reflect(greaterValue);
      if (greaterThanOrEqual != null) {
        expect(valueMirror.invoke(gte, [greaterValue]).reflectee, isFalse, reason: "value >= greaterValue");
        expect(greaterValueMirror.invoke(gte, [value]).reflectee, isTrue, reason: "greaterValue >= value");
      }
      if (lessThanOrEqual != null) {
        expect(valueMirror.invoke(lte, [greaterValue]).reflectee, isTrue, reason: "value <= greaterValue");
        expect(greaterValueMirror.invoke(lte, [value]).reflectee, isFalse, reason: "greaterValue <= value");
      }
      // Now move up to the next pair...
      value = greaterValue;
    }
  }

  /// <summary>
  ///   Tests the equality and inequality operators (==, !=) if they exist on the object.
  /// </summary>
  /// <typeparam name="T">The type to test.</typeparam>
  /// <param name="value">The base value.</param>
  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
  /// <param name="unequalValue">The value not equal to the base value.</param>
  static void TestOperatorEquality<T>(T value, T equalValue, T unequalValue) {
    ValidateInput(value, equalValue, [unequalValue], "unequalValue");

    InstanceMirror valueMirror = reflect(value);
    InstanceMirror equalValueMirror = reflect(equalValue);
    ClassMirror classMirror = reflectClass(/*T*/value.runtimeType);

    var equ = new Symbol("==");
    var equality = classMirror.declarations[equ];

    if (equality != null) {
      // if (!type.GetTypeInfo().IsValueType)
      {
        // expect(equality.Invoke(null, [ null, null ], isTrue, reason: "null == null");
        expect(valueMirror.invoke(equ, [null]).reflectee, isFalse, reason: "value == null");
        // expect(equality.Invoke(null, [ null, value ], isFalse, reason: "null == value");
      }
      expect(valueMirror.invoke(equ, [value]).reflectee, isTrue, reason: "value == value");
      expect(valueMirror.invoke(equ, [equalValue]).reflectee, isTrue, reason: "value == equalValue");
      expect(equalValueMirror.invoke(equ, [value]).reflectee, isTrue, reason: "equalValue == value");
      expect(valueMirror.invoke(equ, [unequalValue]).reflectee, isFalse, reason: "value == unequalValue");
    }
    /*
    var inequality = type.GetMethod("op_Inequality", [ type, type ]);
    if (inequality != null)
    {
    if (!type.GetTypeInfo().IsValueType)
    {
    // expect(inequality.Invoke(null, [ null, null ], isFalse, reason: "null != null");
    expect(inequality.Invoke(null, [ value, null ], isTrue, reason: "value != null");
    // expect(inequality.Invoke(null, [ null, value ], isTrue, reason: "null != value");
    }
    expect(inequality.Invoke(null, [ value, value ], isFalse, reason: "value != value");
    expect(inequality.Invoke(null, [ value, equalValue ], isFalse, reason: "value != equalValue");
    expect(inequality.Invoke(null, [ equalValue, value ], isFalse, reason: "equalValue != value");
    expect(inequality.Invoke(null, [ value, unequalValue ], isTrue, reason: "value != unequalValue");
    }*/
  }

  /// <summary>
  /// Validates that the input parameters to the test methods are valid.
  /// </summary>
  /// <param name="value">The base value.</param>
  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
  /// <param name="unequalValues">The values not equal to the base value.</param>
  /// <param name="unequalName">The name to use in "not equal value" error messages.</param>
  static void ValidateInput(Object value, Object equalValue, List unequalValues, String unequalName) {
    //Assert.NotNull(value, "value cannot be null in TestObjectEquals() method");
    //Assert.NotNull(equalValue, "equalValue cannot be null in TestObjectEquals() method");
    //Assert.AreNotSame(value, equalValue, "value and equalValue MUST be different objects");
    expect(value, isNotNull, reason: "value cannot be null in TestObjectEquals() method");
    expect(equalValue, isNotNull, reason: "equalValue cannot be null in TestObjectEquals() method");
    expect(identical(equalValue, value), isFalse, reason: "value and equalValue MUST be different objects");

    for (var unequalValue in unequalValues) {
      expect(unequalName, isNotNull, reason: unequalName + " cannot be null in TestObjectEquals() method");
      expect(identical(value, unequalValue), isFalse, reason: unequalName + " and value MUST be different objects");

      //Assert.NotNull(unequalValue, unequalName + " cannot be null in TestObjectEquals() method");
      //Assert.AreNotSame(value, unequalValue, unequalName + " and value MUST be different objects");
    }
  }

  /// <summary>
  /// Validates that the input parameters to the test methods are valid.
  /// </summary>
  /// <param name="value">The base value.</param>
  /// <param name="equalValue">The value equal to but not the same object as the base value.</param>
  /// <param name="unequalValue">The value not equal to the base value.</param>
  /// <param name="unequalName">The name to use in "not equal value" error messages.</param>
  static void ValidateInput_Single(Object value, Object equalValue, Object unequalValue, String unequalName)
  {
    ValidateInput(value, equalValue, [ unequalValue ], unequalName);
  }
}