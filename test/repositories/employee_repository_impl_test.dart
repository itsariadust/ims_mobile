import 'package:flutter_test/flutter_test.dart';
import 'package:ims_mobile/domain/entities/employee/employee.dart';
import 'package:ims_mobile/models/employee/employee_api_model.dart';
import 'package:ims_mobile/repositories/implementation/employee_repository_impl.dart';
import 'package:ims_mobile/services/employee_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([EmployeeService])
import 'employee_repository_impl_test.mocks.dart';
void main() {
  late EmployeeRepositoryImpl repo;
  late MockEmployeeService mockEmployeeService;

  setUp(() {
    mockEmployeeService = MockEmployeeService();
    repo = EmployeeRepositoryImpl(mockEmployeeService);
  });

  group('EmployeeRepository', () {
    final employeeDtoList = [
      EmployeeApiModel(
        id: 1,
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        contactNumber: '+1234567890',
        role: 'ADMIN'
      ),
      EmployeeApiModel(
        id: 2,
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane.doe@example.com',
        contactNumber: '+123456789',
        role: 'MANAGER'
      )
    ];

    test('getEmployeeList returns a list of employees', () async {
      when(mockEmployeeService.fetchAllEmployees()).thenAnswer((_) async => employeeDtoList);

      final result = await repo.getEmployeeList();

      expect(result, isA<List<Employee>>());
    });

    test('getEmployee returns an Employee', () async {
      when(mockEmployeeService.fetchEmployee(1)).thenAnswer((_) async => employeeDtoList[0]);
      
      final result = await repo.getEmployee(1);
      
      expect(result, isA<Employee>());
    });
  });
}