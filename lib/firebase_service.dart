

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{
        CollectionReference categories = FirebaseFirestore.instance.collection('categorise');
        CollectionReference mainCart = FirebaseFirestore.instance.collection('mainCategorise');
        CollectionReference subCart = FirebaseFirestore.instance.collection('subCategorise');
        CollectionReference sellers = FirebaseFirestore.instance.collection('sellers');
        CollectionReference products = FirebaseFirestore.instance.collection('products');

        Future<void> saveCategory({CollectionReference? reference, Map<String,dynamic>? data, String? docName}){

          return reference!.doc(docName).set(data);

        }


        Future<int> getTotalSellers() async {
                // Implement the logic to get the total number of sellers
                QuerySnapshot querySnapshot = await sellers.get();
                return querySnapshot.size;
        }

        Future<int> getTotalProducts() async {
                // Implement the logic to get the total number of products
                QuerySnapshot querySnapshot = await products.get();
                return querySnapshot.size;
        }

        Future<Map<String, int>> getCategoryProductCount() async {
                // Implement the logic to get category-wise product counts
                QuerySnapshot querySnapshot = await products.get();
                Map<String, int> categoryCountMap = {};

                for (QueryDocumentSnapshot document in querySnapshot.docs) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        String category = data['category']; // Assuming 'category' is a field in your products
                        categoryCountMap[category] = (categoryCountMap[category] ?? 0) + 1;
                }

                return categoryCountMap;
        }
}


