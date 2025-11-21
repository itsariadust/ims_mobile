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

  final mockItemsList = [
    {
      "id": 1,
      "itemName": "Genuine Cowhide Leather Sheets",
      "category": "Leather",
      "location": "Rack A1",
      "supplier": {
        "id": 1,
        "companyName": "Luzon Leatherworks Trading",
        "contactPerson": "Maria Angelica de la Cruz",
        "email": "angelica.delacruz@luzonleather.ph",
        "contactNumber": "+63 917 234 8890",
        "isActive": true
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
        "companyName": "Luzon Leatherworks Trading",
        "contactPerson": "Maria Angelica de la Cruz",
        "email": "angelica.delacruz@luzonleather.ph",
        "contactNumber": "+63 917 234 8890",
        "isActive": true
      },
      "reorderLevel": 15,
      "targetStockLevel": 80,
      "currentStockLevel": 30,
      "isActive": true
    },
  ];

  final mockItem = {
    "id": 1,
    "itemName": "Genuine Cowhide Leather Sheets",
    "category": "Leather",
    "location": "Rack A1",
    "supplier": {
      "id": 1,
      "companyName": "Luzon Leatherworks Trading",
      "contactPerson": "Maria Angelica de la Cruz",
      "email": "angelica.delacruz@luzonleather.ph",
      "contactNumber": "+63 917 234 8890",
      "isActive": true
    },
    "reorderLevel": 20,
    "targetStockLevel": 100,
    "currentStockLevel": 65,
    "isActive": true
  };

  group('ItemService', () {
    test('Fetch items list returns a List of ItemApiModels', () async {
      final response = Response(
          data: mockItemsList,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/items')
      );

      when(mockDio.get('/items')).thenAnswer((_) async => response);

      final suppliers = await itemService.fetchAllItems();

      expect(suppliers, isA<List<ItemApiModel>>());
      expect(suppliers.length, equals(mockItemsList.length));
    });

    test('Fetch item returns an ItemApiModel', () async {
      final response = Response(
          data: mockItem,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/items/1')
      );

      when(mockDio.get('/items/1')).thenAnswer((_) async => response);

      final item = await itemService.fetchItem(1);

      expect(item, isA<ItemApiModel>());
      expect(item.id, equals(mockItem['id']));
    });
  });
}