import 'package:flutter/material.dart';
import 'package:medfast_go/business/activity.dart';
import 'package:medfast_go/business/customers.dart';
import 'package:medfast_go/business/expenses.dart';
import 'package:medfast_go/business/other_incomes.dart';
import 'package:medfast_go/business/purchase_order.dart';
import 'package:medfast_go/business/representative.dart';
import 'package:medfast_go/business/sales.dart';
import 'package:medfast_go/business/stores.dart';
import 'package:medfast_go/business/suppliers.dart';
import 'package:medfast_go/pages/bottom_navigation.dart';
import 'package:medfast_go/pages/components/tile.dart';
import 'package:medfast_go/pages/widgets/navigation_drawer.dart';


class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});


  //Function for navigation tile
  void navigateToPage(BuildContext context, String pageTitle){

    switch (pageTitle) {

      case 'Sales':
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Sales(initialProducts: [],)));
        break;
      case 'Expenses':
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Expenses()));
        break;
      case 'Stores':
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Stores()));
        break;
      case 'Purchase Order':
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const PurchaseOrder()));
        break;
      case 'Supplier':
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Supplier()));
        break;
      case 'Activity':
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Activity()));
        break;
      case 'Customers':
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Customers()));
        break;
      case 'Representative':
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Representative()));
        break;
      case 'Other Income':
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => OtherIncome()));
        break;
      default:
        Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const BottomNavigation()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 16, 253, 44),
        elevation: 10.0,
        title: Row(

          children: [
            Padding(
              padding: const EdgeInsets.only(right: 13),
              child: Text(
                'Tala Chemist',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            
          ),
          ],
        ),

        actions: [

          IconButton(
            onPressed: () {

            }, 
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),

           IconButton(
            onPressed: () {

            }, 
            icon: Icon(
              Icons.help_outline_rounded,
              color: Colors.white,
            ),
          ),

          
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.9,
        child: const NavigationDrawerWidget(),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          GestureDetector
          (
            onTap: () => navigateToPage(context, "Sales"),
            child: buildTile("sales")
          ),
          GestureDetector
          (
            onTap: () => navigateToPage(context, "Expenses"),
            child: buildTile("Expenses")
          ),
          GestureDetector
          (
            onTap: () => navigateToPage(context, "Stores"),
            child: buildTile("Stores")
          ),
          GestureDetector
          (
            onTap: () => navigateToPage(context, "Purchase Order"),
            child: buildTile("Purchase Order")
          ),
          GestureDetector
          (
            onTap: () => navigateToPage(context, "Supplier"),
            child: buildTile("Supplier")
          ),
          GestureDetector
          (
            onTap: () => navigateToPage(context, "Activity"),
            child: buildTile("Activity")
          ),
          GestureDetector
          (
            onTap: () => navigateToPage(context, "Customers"),
            child: buildTile("Customers")
          ),
          GestureDetector
          (
            onTap: () => navigateToPage(context, "Representative"),
            child: buildTile("Representative")
          ),
          GestureDetector(
            onTap: () => navigateToPage(context, "Other Income"),
            child: buildLongTile("Other Income", context)
          ),
        ],
      ),
    );
  }
}