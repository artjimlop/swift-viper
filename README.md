VIPER-SWIFT
===========

An example Todo list app written in Swift using the VIPER architecture. I found this code some time ago and fixed some things. Anyone interested in improving it is welcome :)

# Main Parts of VIPER

The main parts of VIPER are:

View: displays what it is told to by the Presenter and relays user input back to the Presenter.

Interactor: contains the business logic as specified by a use case.

Presenter: contains view logic for preparing content for display (as received from the Interactor) and for reacting to user inputs (by requesting new data from the Interactor).

Entity: contains basic model objects used by the Interactor.

Routing: contains navigation logic for describing which screens are shown in which order.

This separation also conforms to the Single Responsibility Principle. The Interactor is responsible to the business analyst, the Presenter represents the interaction designer, and the View is responsible to the visual designer.
