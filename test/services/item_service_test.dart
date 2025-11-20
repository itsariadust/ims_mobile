import 'package:flutter_test/flutter_test.dart';
import 'package:ims_mobile/models/item/item_api_model.dart';
import 'package:ims_mobile/services/item_service.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;
  late ItemService itemService;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(mockApiClient.dio).thenReturn(mockDio);
    itemService = ItemService(mockApiClient);
  });

  final mockSuppliersList = [
    {
      "id": 1,
      "itemName": "Genuine Cowhide Leather Sheets",
      "category": "Leather",
      "location": "Rack A1",
      "supplier": {
        "id": 1,
        "companyName": "Luzon Leatherworks Trading"
      },
      "reorderLevel": 20,
      "targetStockLevel": 100,
      "currentStockLevel": 65,
      "isActive": true
    },
    {
      "id": 2,
      "itemName": "Synthetic PU Leather Roll",
      "category": "Leather",
      "location": "Rack A2",
      "supplier": {
        "id": 1,
        "companyName": "Luzon Leatherworks Trading"
      },
      "reorderLevel": 15,
      "targetStockLevel": 80,
      "currentStockLevel": 30,
      "isActive": true
    },
  ];

  group('ItemService', () {
    test('Fetch items list returns a List of ItemApiModels', () async {
      final response = Response(
          data: mockSuppliersList,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/items')
      );

      when(mockDio.get('/items')).thenAnswer((_) async => response);

      final suppliers = await itemService.fetchAllItems();

      expect(suppliers, isA<List<ItemApiModel>>());
      expect(suppliers.length, equals(mockSuppliersList.length));
    });
  });
}