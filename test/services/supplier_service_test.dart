import 'package:flutter_test/flutter_test.dart';
import 'package:ims_mobile/models/supplier/supplier_api_model.dart';
import 'package:ims_mobile/services/supplier_service.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;
  late SupplierService supplierService;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(mockApiClient.dio).thenReturn(mockDio);
    supplierService = SupplierService(mockApiClient);
  });

  final mockSuppliersList = [
    {
      'id': 1,
      'companyName': 'Company A',
      'contactPerson': 'John Doe',
      'email': 'john.doe@example.com',
      'contactNumber': '+1234567890'
    },
    {
      'id': 2,
      'companyName': 'Company B',
      'contactPerson': 'Jane Doe',
      'email': 'jane.doe@example.com',
      'contactNumber': '+2345678901'
    }
  ];

  group('SupplierService', () {
    test('Fetch suppliers list returns a List of SupplierApiModels', () async {
      final response = Response(
        data: mockSuppliersList,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/suppliers')
      );

      when(mockDio.get('/suppliers')).thenAnswer((_) async => response);

      final suppliers = await supplierService.fetchAllSuppliers();

      expect(suppliers, isA<List<SupplierApiModel>>());
      expect(suppliers.length, equals(mockSuppliersList.length));
    });
  });
}