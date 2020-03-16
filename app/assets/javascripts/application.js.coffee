//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require datatable
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require meiomask
//= require app_control
//= require chosen-jquery
//= require twitter/bootstrap
//= require twitter/bootstrap/rails/confirm
//= require rails.validations
//= require rails.validations.simple_form
//= require rails.validations.customValidators
#//= require metisMenu
//= require raphael
//= require sb-admin-2

app_control.init_before()
# roda funções de inicialização
@$ ->
  ready()

# inicialização
@ready = () ->
  # enable chosen js
  window.initialize_objects()

  $('.modal').on 'shown.bs.modal', ->
    window.initialize_objects()

  $('.btn-new').click ->
    url = $(this).data("url")
    callback = $(this).data("callback")
    modal_form({ url: url, callback: callback})

  $.fn.twitter_bootstrap_confirmbox.defaults = {
    fade: true,
    title: "Confirmação",
    cancel: "Cancelar",
    cancel_class: "btn cancel",
    proceed: "Confirmar",
    proceed_class: "btn proceed btn-primary"
  };
