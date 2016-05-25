app = (function() {

  var data = null;

  function getData() {
    $.ajax({
      dataType: 'json',
      url: '/data/gems-approved.json',
      success: function(d) {
        data = d;
        loader();
      }
    });

  }

  function getRandom() {
    window.location.hash = '';
    loader();
  }

  $('.random').on('click', getRandom);

  function loader() {
    var id = getGemIndex();
    getGem(id);
    setGem(getGem(id), id);
  }


  function getGemIndex() {
    var hash = window.location.hash,
        gemIndex = 0;
    if (hash) {
      gemIndex = hash.replace('#', '');
    } else {
      gemIndex = Math.floor((Math.random() * data.length) + 1);
    }
    return gemIndex;
  }

  function getGem(id) {
    return data[id];
  }

  function setGem(gem, id) {
    $('.gem').html(fixedGem(gem));
    $('.linky').attr('href', '#' + id).text('Link this Gem!');
    emojify.run();
  }

  function fixedGem(gem) {
    return gem.replace(/\r?\\n/g, '<br>').replace(/\\"/g, '"').replace('"&gt;', '');
  }
  (function init() {
    if (data === null) {
      getData();
    } else {
      loader();
    }
  })();

  return {
    loader: loader
  };
})();
