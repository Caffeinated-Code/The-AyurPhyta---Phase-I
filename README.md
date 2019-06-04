# The-AyurPhyta (tAP)

##Phase I:
Data Retrieval from Primary Databases by leveraging APIs and in their absence, a combination of curl/wget requests and parsing with the help of RegEx and certain perl modules

Example   Dr.Duke's Phytochemical and Ethnobotanical Database 
          (https://phytochem.nal.usda.gov/phytochem/search)
          
          Data needed        : Scientific and Common Name of Plants; Plant ID; Family Name; 
          Perl Program 1     : DRDUKES_PLANTDETAILS_PARSER.pl
          Sample O/P files   : plantID.1.txt, DrDukes_PlantID_Name_Family.txt
          Data needed        : Phytochemical constituents of each plant, corresponding PhytoChemical ID, corresponding activities
          
##Phase II:
Creation of a pilot scale database using 92 non-ubiquitous phytochemicals from the top 5 commonly used Ayurvedic medicinal plants while establishing ~200k Phytochemical-Predicted Activity associations using MySQL Workbench 8.0

