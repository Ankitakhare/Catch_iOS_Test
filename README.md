# Catch_iOS_Test

**GuideLine to run this codebase.**************************************
Requirment to Build the App 
Xcode (an IDE), you can build or publish iOS apps.  macOS with the iOS SDK. (I have use the  xcode Version 13.4.1 (13F100) and Simulatore Kit 618).
Run this code base in xcode By selecting the Target TestAnkita in simulator with any iphone device selection . I have tested this app in simulator for all.
iphone device.
Once you run the app with command R app build successfully and launch the app into simulator selected device.
User can test it in their own personal device as well by connecting it accepting the cert from the setting device and management by allowing the certficate as currenty . I am not Having any iphone device so tested fully on simulator .

********************

Spend time on app as well the detail about the architechture and process how i have developed the app .************************************


The App uses VIPER architecture. The intent was reusability and loosely coupled code. It also showcases protocol oriented programming. 
The protocols used are :- 

ListViewProtocol (View) 

It has a method called reloadView

ListViewController confirms the ListViewProtocol. 

InteractorProtocol (Interactor) - it handles the API calls (via URLSession in our case)

ListInteractor confirms to the InteractorProtocol

PresenterProtocol (Presenter)

ListPresenter confirms to the PresenterProtocol

hostView (It is of type ListViewProtocol, here in our case it will be ListViewController), this is a reference to the view from the presenter. 
loadingState. (It is an enum -> with values dataRefresh, dataLoad and none).
dataRefresh is when we swipe the table view (i.e. pull to refresh table view). This state happens when the api returns 

dataLoad is loading the screen initially -> pull to data refresh isn’t called.

ListViewModel is created which handles the model for views. (Based on the view’s requirements, only those properties are added to the model. Let’s say if the api returns more information, that will not be mapped to this model). 

Presenter provides the view model for each indexpath of the tableview. (cellForRowAt). 

Presenter handle selection handles the routing requirement. 

Model (Entity) 

RouterProtocol (Router) 

ListRouter confirms to the RouterProtocol

Viewcontroller gets data from the presenter. Presenter gets the data from the interactor (it makes the API calls). Presenter owns the model (Model. It is a struct with properties id, title, subtitle and content). Router is for routing. If we tap on the tableviewcell, the router handles the navigation. 

REFER TO THE DIAGRAM

View controller has a TableView. VC will ask the Presenter for data. Presenter asks the Interactor for data. Interactor makes the API call (URLSession). Data is given back via closures. Ask for data and give it back via closures. Presenter has a reference to the Model (owns the model). 

The connections are made in the scene delegate (willConnectTo). getListVC of the router gets called.

Created two view class one for the CircularProgress bar view   and another BlackProgressview  for the animation and refreshcontrol for the reload and refresh the data 

