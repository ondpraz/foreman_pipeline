angular.module('ForemanPipeline.jobs').controller('JobDetailsContentViewsController',
    ['$scope', '$q', '$location','translate', 'Job', 'ContentView', 'Nutupane', 
        function ($scope, $q, $location, translate, Job, ContentView, Nutupane) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            params = {
                'search': $location.search().search || "",
                'sort_by': 'name',
                'sort_order': 'ASC',
                'nondefault': true,
                'noncomposite': true,
            };

            $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
            });

            var cvNutupane = new Nutupane(ContentView, params);
            $scope.nutupane = cvNutupane;
            $scope.cvTable = cvNutupane.table;
            cvNutupane.query();

            $scope.setContentView = function () {
                var success,
                    error,
                    deferred = $q.defer();

                    $scope.chosen = $scope.cvTable.chosenRow;
                    data = {content_view_id: $scope.chosen.id};

                    success = function (response) {
                        deferred.resolve(response);
                        $scope.successMessages.push(translate('New Content View successfully set.'));
                        $scope.cvTable.working = false;
                        cvNutupane.refresh();
                        $scope.job.content_view = $scope.chosen;
                        $scope.cvTable.chosenRow = null;
                    };                 

                    error = function (response) {
                        deferred.reject(response);
                        angular.forEach(response.data.errors, function (errorMessage, key) {
                            $scope.errorMessages.push(translate('Error occured while saving Job: ') + errorMessage);
                        });
                        $scope.cvTable.working = false;
                    };

                    $scope.cvTable.working = true;
                    Job.setContentView({id: $scope.job.id}, data, success, error);
                    return deferred.promise;
            };          
        }
    ]);