(function() {
  var fetchStates, fetchCities, fetchSchools;

  fetchStates = function (country_id) {
    $.ajax({
      type: 'GET',
      url: '/pays/' + country_id,
      dataType: 'script',
      success: function()  {
        $('#finding_school #state_id').select2({language: 'fr'});
        $('#finding_school #state_id').on('change', function() {
          var state_id = $(this).val();
          fetchCities(country_id, state_id);
        });
      }
    });
  };

  fetchCities = function(country_id, state_id) {
    $.ajax({
      type: 'GET',
      url: '/pays/' + country_id + '/dpt/' + state_id,
      dataType: 'script',
      success: function() {
        $('#finding_school #city_id').select2({language: 'fr'});
        $('#finding_school #city_id').on('change', function() {
          var city_name = $(this).val();
          fetchSchools(country_id, state_id, city_name);
        });
      }
    });
  };

  fetchSchools = function(country_id, state_id, city_name) {
    $.ajax({
      type: 'GET',
      url: '/pays/' + country_id + '/dpt/' + state_id + '/ville/' + city_name,
      dataType: 'script',
      success: function() {
        $('#finding_school select[id$=_school_id]').select2({
          language: 'fr',
          width: '100%'
        });
      }
    });
  };

  document.addEventListener('turbolinks:load', function(e) {
    $('#finding_school select[id$=_school_id]').closest('div').hide();
    $('#finding_school #country_id').on('change', function() {
      var country_id = $(this).val();
      fetchStates(country_id);
    });
  });
}).call(this);
