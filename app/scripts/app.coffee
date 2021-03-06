tractatus = angular.module('tractatus-tree', ['ngRoute'])
tractatus.config ['$routeProvider', ($routeProvider)->
    $routeProvider.when '/',
        controller: 'MainCtrl'
        templateUrl: "partials/home.html"
]

tractatus.config(["$provide", ($provide)->

    $provide.decorator("$rootScope", [ "$delegate", ($delegate)->
        $delegate.safeApply = (fn)->
            phase = $delegate.$$phase
            if (phase is "$apply") or (phase is "$digest")
                if (fn) && (typeof(fn) is typeof(''))
                    fn()
            else
                $delegate.$apply(fn)
        $delegate
    
    ])
])


tractatus.controller('MainCtrl', ['$scope', '$sce', 'constant.events', ($scope, $sce, EVENTS)->
    languages =
        en: 'English'
        de: 'German'

    $scope.selectedLanguage = 'en'
    $scope.selectedNode = undefined

    $scope.$on EVENTS.node.selected, (evt, node)->
        $scope.safeApply ->
            $scope.selectedNode = node
            return

    $scope.selectLang = (lang)->
        $scope.selectedLanguage = lang
        return

    $scope.getLanguages = (lang)->
        _.map _.keys($scope.selectedNode.content), (v)->
            key: v
            value: languages[v]

    $scope.isSelectedLang = (lang)->
        selected = $scope.selectedLanguage == lang
        selected

    $scope.getContent = ->
        node = $scope.selectedNode
        if node.content
            return $sce.trustAsHtml(node.content[$scope.selectedLanguage])
        return
    return

])

#= require constants.coffee
#= require tractatus-graph.coffee