@custom_datatable = (dom_id, columns, row_callback) ->
  $("#" + dom_id).dataTable
    columns: columns
    language: language_datatable
    bLengthChange: false
    bInfo: true
    paginate: true,
    serverSide: true,
    iDisplayLength: 25,
    ajax: $("#" + dom_id).data('source')
    fnRowCallback: row_callback
    drawCallback: datatable_draw_callback

window.language_datatable = {
  "sEmptyTable": "Nenhum registro encontrado",
  "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
  "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
  "sInfoFiltered": "(Filtrados de _MAX_ registros)",
  "sInfoPostFix": "",
  "sInfoThousands": ".",
  "sLengthMenu": "_MENU_ resultados por página",
  "sLoadingRecords": "Carregando...",
  "sProcessing": "Processando...",
  "sZeroRecords": "Nenhum registro encontrado",
  "sSearch": "Pesquisar",
  "oPaginate": {
      "sNext": "Próximo",
      "sPrevious": "Anterior",
      "sFirst": "Primeiro",
      "sLast": "Último"
  },
  "oAria": {
      "sSortAscending": ": Ordenar colunas de forma ascendente",
      "sSortDescending": ": Ordenar colunas de forma descendente"
  }
}
