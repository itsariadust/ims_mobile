import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:ims_mobile/services/employee_service.dart';
import 'package:ims_mobile/models/employee/employee_api_model.dart';
import '../mocks.mocks.dart';

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;
  late EmployeeService employeeService;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(mockApiClient.dio).thenReturn(mockDio);
    employeeService = EmployeeService(mockApiClient);
  });

  final mockEmployeeList = [
    {
      "id": 1,
      "firstName": "John",
      "lastName": "Doe",
      "email": "john.doe@example.com",
      "contactNumber": "+1234567890",
      "role": "ADMIN"
    },
    {
      "id": 2,
      "firstName": "Jane",
      "lastName": "Doe",
      "email": "jane.doe@example.com",
      "contactNumber": "+123456789",
      "role": "MANAGER"
    }
  ];

  group('EmployeeService', () {
    test('fetch Employee list returns list of employees on success', () async {
      final response = Response(
        data: mockEmployeeList,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/employees')
      );

      when(mockDio.get('/employees')).thenAnswer((_) async => response);

      final employees = await employeeService.fetchAllEmployees();

      expect(employees, isA<List<EmployeeApiModel>>());
      expect(employees.length, equals(mockEmployeeList.length));
      verify(mockDio.get(any)).called(1);
    });
  });

  test('fetch employee returns the employee itself', () async {
    final response = Response(
      data: mockEmployeeList[0],
      statusCode: 200,
      requestOptions: RequestOptions(path: '/employees/1')
    );

    when(mockDio.get('/employees/1')).thenAnswer((_) async => response);

    final employee = await employeeService.fetchEmployee(1);

    expect(employee, isA<EmployeeApiModel>());
    expect(employee.id, equals(mockEmployeeList[0]['id']));
    verify(mockDio.get(any)).called(1);
  });
}