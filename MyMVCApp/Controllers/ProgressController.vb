Imports WalkingMVC.WalkingDB

Namespace WalkingMVC
    Public Class ProgressController
        Inherits System.Web.Mvc.Controller

        '====Define the repository as the interface. Seperated from the constructor to aid inversion of control=======
        Dim _repository As IWalkingRepository

        '=====Constructor for the repository object==============================
        Public Sub New()
            _repository = New SqlWalkingRepository

        End Sub
        '
        ' GET: /Progress

        Function Index(Optional ByVal classtype As String = "f") As ActionResult

            Dim oProgress As List(Of MyProgress) = _repository.GetMyProgressByClassType(classtype)
            ViewData("oProgress") = oProgress
            Return View()

        End Function

    End Class
End Namespace