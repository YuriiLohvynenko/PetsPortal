// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


import "css/site"
import 'jquery'
import '@popperjs/core'
import 'bootstrap'


$(document).on('turbolinks:load', function() {

    $('.toggle-comment-form').on('click', function() {
        $(this).siblings('.comment-form').toggle();
      });

    $('.toggle-new-comment-form').on('click', function(event) {
      $(this).siblings('.new-comment-form').toggle();
    });

    checkPrefectureSelection();
    // Get the category and subcategory select elements
    var categorySelect = $('#category-select');
    var subcategorySelect = $('#subcategory-select');

    // Handle the change event of the category select
    categorySelect.on('change', function() {
      var categoryId = $(this).val();
      console.log(categoryId);

      // Make an AJAX request to fetch the subcategories for the selected category
      $.ajax({
        url: '/categories/' + categoryId + '/subcategories',
        method: 'GET',
        dataType: 'json',
        success: function(data) {
          // Clear the existing subcategory options
          subcategorySelect.empty();
          console.log(data);

          // Add the default prompt option
          subcategorySelect.append('<option value="">中分類を選んでください</option>');

          // Append the fetched subcategories as options
          $.each(data, function(index, subcategory) {
            subcategorySelect.append('<option value="' + subcategory.id + '">' + subcategory.name + '</option>');
          });
        },
        error: function() {
          console.log('Error fetching subcategories.');
        }
      });
    });






    // Get the category and subcategory select elements
    var categorySelect2 = $('#category-select2');
    var subcategorySelect2 = $('#subcategory-select2');

    // Handle the change event of the category select
    var radioContainer = $('#radio-container');
    radioContainer.on('change', 'input[type="radio"]', function() {
      var categoryId = $(this).val();

      // Make an AJAX request to fetch the subcategories for the selected category
      $.ajax({
        url: '/categories/' + categoryId + '/subcategories',
        method: 'GET',
        dataType: 'json',
        success: function(data) {
          // Clear the existing subcategory options
          subcategorySelect2.empty();

          // Add the default prompt option
        //   subcategorySelect2.append('<option value="">Select Subcategory</option>');

          // Append the fetched subcategories as options
          $.each(data, function(index, subcategory) {
            subcategorySelect2.append('<option value="' + subcategory.id + '">' + subcategory.name + '</option>');
          });
        },
        error: function() {
          console.log('Error fetching subcategories.');
        }
      });
    });


    // Get the category and subcategory select elements
    var categorySelect3 = $('#category-select3');
    var subcategorySelect3 = $('#subcategory-select3');

    // Handle the change event of the category select
    categorySelect3.on('change', function() {
      var categoryId = $(this).val();
      console.log(categoryId);

      // Make an AJAX request to fetch the subcategories for the selected category
      $.ajax({
        url: '/categories/' + categoryId + '/subcategories',
        method: 'GET',
        dataType: 'json',
        success: function(data) {
          // Clear the existing subcategory options
          subcategorySelect3.empty();

          // Add the default prompt option
        //   subcategorySelect2.append('<option value="">Select Subcategory</option>');

          // Append the fetched subcategories as options
          $.each(data, function(index, subcategory) {
            subcategorySelect3.append('<option value="' + subcategory.id + '">' + subcategory.name + '</option>');
          });
        },
        error: function() {
          console.log('Error fetching subcategories.');
        }
      });
    });

  $('#filterButton').click(function() {
    $('#filterBox').toggle();
  });




  $('#prefecture-select').on('change', function() {
    var selectedRegion = $(this).val();
    var citySelect = $('#city-select');

    // Fetch the JSON data using AJAX
    $.ajax({
      url: '/prefectures_with_cities.json',
      method: 'GET',
      dataType: 'json',
      success: function(regionsWithCities) {
        var cities = regionsWithCities[selectedRegion] || [];

        // Clear existing city options and add the new ones based on the cities array
        citySelect.empty();
        citySelect.append($('<option>', { value: '', text: '市町村を選択' }));
        $.each(cities, function(index, city) {
          citySelect.append($('<option>', { value: city, text: city }));
        });
      },
      error: function() {
        console.log('Error fetching regions with cities.');
      }
    });
  })

});

function checkPrefectureSelection() {
  var selectedPrefecture = $('#prefecture-select').val();
  if (selectedPrefecture) {
    fetchCitiesForPrefecture(selectedPrefecture);
  }
}

function fetchCitiesForPrefecture(prefecture) {
  var citySelect = $('#city-select');

  // Fetch the JSON data using AJAX
  $.ajax({
    url: '/prefectures_with_cities.json',
    method: 'GET',
    dataType: 'json',
    success: function(regionsWithCities) {
      var cities = regionsWithCities[prefecture] || [];

      // Clear existing city options and add the new ones based on the cities array
      citySelect.empty();
      citySelect.append($('<option>', { value: '', text: '市町村を選択' }));
      $.each(cities, function(index, city) {
        citySelect.append($('<option>', { value: city, text: city }));
      });
    },
    error: function() {
      console.log('Error fetching regions with cities.');
    }
  });
}

$('#prefecture-select').on('change', function() {
  var selectedRegion = $(this).val();
  fetchCitiesForPrefecture(selectedRegion);
});

document.addEventListener("DOMContentLoaded", function() {
  // 編集ボタンがクリックされた時の処理
  document.querySelectorAll('.edit-answer-btn').forEach(function(btn) {
    btn.addEventListener('click', function(e) {
      let answerId = e.target.getAttribute('data-answer-id');
      document.getElementById(`answer-text-${answerId}`).style.display = 'none';
      document.getElementById(`answer-edit-${answerId}`).style.display = 'block';
    });
  });

  // キャンセルボタンがクリックされた時の処理
  document.querySelectorAll('.cancel-edit-btn').forEach(function(btn) {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      let answerId = e.target.getAttribute('data-answer-id');
      document.getElementById(`answer-edit-${answerId}`).style.display = 'none';
      document.getElementById(`answer-text-${answerId}`).style.display = 'block';
    });
  });
});
