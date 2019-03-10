(function() {
    'use strict';

    angular.module('seeawayApp').controller('Ph3aCtrl', Ph3Ctrl);

    Ph3Ctrl.$inject = ['ph3aService', '$filter'];

    function Ph3Ctrl(ph3aService, $filter) {

        var vm = this;
        vm.init = init;
        vm.cpfChange = cpfChange;

        function init() {
            console.info('ph3a init');

            vm.datasource = {
                Person: {
                    FullName: ''
                },
                name: '',
                cpf: '',
                children: [],
                relationship: '111'
            };

            updateOrgChart();
        }

        function updateOrgChart() {

            $('#chart-container').empty();

            $('#chart-container').orgchart({
                    'data': vm.datasource,
                    'pan': true,
                    //'zoom': true,
                    //'exportButton': true,
                    //'exportFilename': 'Exportar',                    
                    /*'createNode': function($node, data) {
                        $node[0].id = getId();
                    }*/
                    'createNode': function($node, data) {
                        var content = '<div layout="row">';

                        /*if (data.Person) {
                            content = content.concat('<div class="title-custom">' + data.Person.FullName + '</div>');
                        } else if (data.LegalName)
                            content = content.concat('<div class="title-custom">' + data.LegalName + '</div>');
                        else {
                            content = content.concat('<div class="title">' + '?' + '</div>');
                        }*/
                        if (data.name && data.name !== '') {
                            content = content.concat('<div class="title-custom title-' + data.class + '">' + data.name + '</div>');
                        }

                        // Child
                        if (data.type) {
                            switch (data.type) {

                                case 0:
                                    // Pessoa
                                    if (data.cpf && data.cpf !== '') {
                                        content = content.concat('<div class="content-custom content-' + data.class + '">' +
                                            '   <div layout="row" layout-align="start center">' +
                                            '       <div>' +
                                            '           <div><b>CPF:</b> ' + $filter('brCpf')(data.cpf) + '</div>' +
                                            '       </div>' +
                                            '   </div>' +
                                            '</div>');
                                    }
                                    break;

                                case 1:
                                    // Veículo
                                    content = content.concat('<div class="content-custom content-' + data.class + '">' +
                                        '   <div layout="row" layout-align="start center">' +
                                        '       <div>' +
                                        '           <div><b>Marca:</b> ' + data.marca + '</div>' +
                                        '           <div><b>Modelo:</b> ' + data.modelo + '</div>' +
                                        '           <div><b>Ano:</b> ' + data.ano + '</div>' +
                                        '           <div><b>Placa:</b> ' + data.placa + '</div>' +
                                        '       </div>' +
                                        '   </div>' +
                                        '</div>');
                                    break;

                                default:
                                    break;
                            }
                        } else { // Pai
                            if (data.cpf && data.cpf !== '') {

                                var scoreHtml = '';
                                if (data.score) {
                                    scoreHtml = '<div><b>Score:</b> ' + data.score + '</div>';
                                }

                                content = content.concat('<div class="content-custom">' +
                                    '   <div layout="row" layout-align="start center">' +
                                    '       <div>' +
                                    '           <div><b>CPF:</b> ' + $filter('brCpf')(data.cpf) + '</div>' +
                                    '           ' + scoreHtml +
                                    '       </div>' +
                                    //'       <div flex="50" layout="row">' +
                                    //'           <div>a</div>' +
                                    //'       </div>' +
                                    //'       <div flex="50" layout="column">' +
                                    //'           <div>b</div>' +
                                    //'       </div>' +
                                    '   </div>' +
                                    '</div>');
                            }
                        }

                        content = content.concat('</div>');

                        $node.html(content);
                        $node.on('click', function(event) {
                            if (!$(event.target).is('.edge')) {
                                //$('#selected-node').val(data.name).data('node', $node);

                                vm.loading = true;
                                ph3aService.getPersonData({ cpf: data.cpf })
                                    .then(function success(response) {

                                        console.info('click', response);
                                        addChildren($node, response.ph3a);

                                    }, function error(response) {
                                        console.error(response);
                                        vm.loading = false;
                                    });
                            }
                        });
                    }
                })
                /*.on('click', '.node', function() {
                    var $this = $(this);
                    $('#selected-node').val($this.find('.title').text()).data('node', $this);
                    addChildren();
                })*/
                .on('click', '.orgchart', function(event) {
                    if (!$(event.target).closest('.node').length) {
                        $('#selected-node').val('');
                    }
                });

            vm.loading = false;
        }

        function addChildren($node, response) {
            var $chartContainer = $('#chart-container');
            var nodeVals = [];
            nodeVals = response.HouseHoldPersons;
            //nodeVals.push(':)');

            var hasChild = $node.parent().attr('colspan') > 0 ? true : false;
            if (!hasChild) {
                var rel = nodeVals.length > 1 ? '110' : '100';
                $chartContainer.orgchart('addChildren', $node, {
                    'children': nodeVals.map(function(item) {
                        return item;
                        //return { item, 'relationship': rel, 'Id': (new Date()).getTime() };
                    })
                }, $.extend({}, $chartContainer.find('.orgchart').data('options'), { depth: 0 }));
            } else {
                $chartContainer.orgchart('addSiblings', $node.closest('tr').siblings('.nodes').find('.node:first'), {
                    'siblings': nodeVals.map(function(item) { return { 'name': item, 'relationship': '110', 'Id': (new Date()).getTime() }; })
                });
            }

            vm.loading = false;
        }

        function cpfChange() {
            //console.info('cpfChange');

            if (String(vm.ph3a.cpf).length === 11) {

                vm.loading = true;

                ph3aService.getPersonData(vm.ph3a)
                    .then(function success(response) {
                        console.info(response);
                        vm.ph3a.resultado = JSON.stringify(response.ph3a);

                        var children = [];

                        // HouseHoldPersons
                        for (var i = 0; i <= response.ph3a.HouseHoldPersons.length - 1; i++) {
                            children.push({
                                type: 0,
                                class: 'pessoa',
                                name: response.ph3a.HouseHoldPersons[i].LegalName,
                                cpf: response.ph3a.HouseHoldPersons[i].CPF,
                                parentesco: response.ph3a.HouseHoldPersons[i].Kinship,

                            });
                        }

                        // Vehicles
                        for (var j = 0; j <= response.ph3a.Vehicles.length - 1; j++) {
                            children.push({
                                type: 1,
                                class: 'veiculo',
                                name: 'Veículo',
                                marca: response.ph3a.Vehicles[j].Brand,
                                modelo: response.ph3a.Vehicles[j].Model,
                                placa: response.ph3a.Vehicles[j].LicensePlate,
                                ano: response.ph3a.Vehicles[j].ModelYear
                            });
                        }

                        // sample of core source code
                        vm.datasource = {
                            name: response.ph3a.Person.FullName,
                            cpf: response.ph3a.Person.Document,
                            score: response.ph3a.Score,
                            title: response.ph3a.Person.Document,
                            children: children
                        };

                        updateOrgChart();

                    }, function error(response) {
                        vm.loading = true;
                        console.error(response);
                    });
            }
        }

    }
})();