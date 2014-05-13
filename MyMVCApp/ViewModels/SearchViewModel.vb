Imports System.ComponentModel.DataAnnotations
Imports System
Imports System.ComponentModel

Namespace WalkingMVC.ViewModels

    Public Class SearchViewModel

        <Required(ErrorMessage:="Please enter your search terms.")> _
        <StringLength(50, ErrorMessage:="Search terms must be under 50 characters")> _
        <DisplayName("Please enter your search terms: ")> _
        Public Property SearchText As String

        <DisplayName("Search walk descriptions: ")> _
        Public Property SearchWalkDescriptions As Boolean

        <DisplayName("Search image captions: ")> _
        Public Property SearchImageCaptions As Boolean

        Public Property WalkResultsAvailable As Boolean
        Public walksFound As List(Of Walk)

        Public Property ImageResultsAvailable As Boolean
        Public imagesFound As List(Of Walk_AssociatedFile)

    End Class

End Namespace

