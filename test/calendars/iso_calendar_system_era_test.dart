// https://github.com/nodatime/nodatime/blob/master/src/NodaTime.Test/Calendars/IsoCalendarSystemTest.Era.cs
// 7208243  on Mar 18, 2015

import 'dart:async';
import 'dart:math' as math;

import 'package:time_machine/time_machine.dart';
import 'package:time_machine/time_machine_calendars.dart';
import 'package:time_machine/time_machine_utilities.dart';

import 'package:test/test.dart';
import 'package:matcher/matcher.dart';
import 'package:time_machine/time_machine_timezones.dart';

import '../time_machine_testing.dart';

Future main() async {
  await runTests();
}

CalendarSystem Iso = CalendarSystem.Iso;

@Test()
void GetMaxYearOfEra()
{
  LocalDate date = new LocalDate(Iso.maxYear, 1, 1);
  expect(date.YearOfEra, Iso.GetMaxYearOfEra(Era.Common));
  expect(Era.Common, date.era);
  date = new LocalDate(Iso.minYear, 1, 1);
  expect(Iso.minYear, date.Year);
  expect(date.YearOfEra, Iso.GetMaxYearOfEra(Era.BeforeCommon));
  expect(Era.BeforeCommon, date.era);
}

@Test()
void GetMinYearOfEra()
{
  LocalDate date = new LocalDate(1, 1, 1);
  expect(date.YearOfEra, Iso.GetMinYearOfEra(Era.Common));
  expect(Era.Common, date.era);
  date = new LocalDate(0, 1, 1);
  expect(date.YearOfEra, Iso.GetMinYearOfEra(Era.BeforeCommon));
  expect(Era.BeforeCommon, date.era);
}

@Test()
void GetAbsoluteYear()
{
  expect(1, Iso.GetAbsoluteYear(1, Era.Common));
  expect(0, Iso.GetAbsoluteYear(1, Era.BeforeCommon));
  expect(-1, Iso.GetAbsoluteYear(2, Era.BeforeCommon));
  expect(Iso.maxYear, Iso.GetAbsoluteYear(Iso.GetMaxYearOfEra(Era.Common), Era.Common));
  expect(Iso.minYear, Iso.GetAbsoluteYear(Iso.GetMaxYearOfEra(Era.BeforeCommon), Era.BeforeCommon));
}