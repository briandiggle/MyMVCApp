Imports WalkingMVC.WalkingMVC.ViewModels

Namespace WalkingMVC
    Public Class SearchController
        Inherits System.Web.Mvc.Controller

        '====Define the repository as the interface. Seperated from the constructor to aid inversion of control=======
        Dim _repository As IWalkingRepository

        '=====Constructor for the repository object==============================
        Public Sub New()
            _repository = New SqlWalkingRepository

        End Sub

        '
        ' GET: /Search/

        Function Index() As ActionResult

            Return (View())
        End Function

        ''' <summary>
        ''' Walk Search
        ''' </summary>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Function WalkSearch() As ActionResult

            Dim searchViewModel As New SearchViewModel

            Return View(searchViewModel)

        End Function

        <ValidateInput(False)>
        <HttpPost()> _
        Function WalkSearch(ByVal searchViewModel As SearchViewModel) As ActionResult

            If ModelState.IsValid Then

                If searchViewModel.SearchWalkDescriptions Then
                    '---Run the search and populate the view model with the results---
                    Dim walksFound As IQueryable(Of Walk)

                    walksFound = _repository.SearchForWalks(searchViewModel.SearchText)

                    searchViewModel.walksFound = walksFound.ToList
                    searchViewModel.WalkResultsAvailable = True
                    searchViewModel.ImageResultsAvailable = False
                Else
                    searchViewModel.WalkResultsAvailable = False
                End If

            End If

            Return View(searchViewModel)
        End Function


        Function ImageSearch() As ActionResult

            Return (View())

        End Function

        Function MarkerSearch() As ActionResult

            Return (View())

        End Function

        Function HillSearch() As ActionResult

            Return (View())

        End Function

        Function AscentSearch() As ActionResult

            Return (View())

        End Function

    End Class
End Namespace