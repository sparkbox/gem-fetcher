var app = (function() {

  var data = null,
      show = null,
      dmap = null,
      dmapMax = 0;
      dmapIterator = 0;
      SHOW_TIMEOUT = 30 * 1000 ; // 30 seconds

  function getData() {
    $.ajax({
      dataType: 'json',
      url: '/data/gems-approved.json',
      success: function(d) {
        data = d;
        dmapMax = data.length - 1;
        dmap = _.shuffle(range(0, dmapMax));
        loader();
      }
    });

  }

  function getRandom() {
    // This is making history messed up, use something else to
    // get a new random/gem.
    window.location.hash = '';
    loader();
  }

  $('.random').on('click', randomClick);

  $('.toggleShow').on('click', toggleShow);

  $('.linky').on('click', checkShow);

  function toggleShow(e) {
    var $target = $(e.target);
    if ($target.hasClass('running')) {
      stopShow($target);
    } else {
      runShow($target);
    }
  }

  function randomClick() {
    checkShow();
    getRandom();
  }

  function checkShow() {
    var $target = $('.toggleShow');
    if ($target.hasClass('running')) {
      stopShow($target);
    }
  }

  function runShow($target) {
    $('.bar-inner-hold').removeClass('bar-inner');
    if ($target && !$target.hasClass('running')) {
      $target.text('Stop show').addClass('running');
      $('.bar-timer').show();
      $('.bar-inner-hold').addClass('bar-inner');
    }
    $('.bar-inner-hold').addClass('bar-inner');
    show = setTimeout(runShow, SHOW_TIMEOUT);
    getRandom();
  }

  function stopShow($target) {
    $target.removeClass('running').text('Start show');
    $('.bar-timer').hide();
    $('.bar-inner-hold').removeClass('bar-inner');
    clearTimeout(show);
    show = null;
  }

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
      if (gemIndex === 'latest') {
        gemIndex = data.length - 1;
      }
    } else {
      gemIndex = dmap[dmapIterator];
      dmapIterator++;
      if (dmapIterator > dmapMax) {
        dmapIterator = 0;
      }
      // gemIndex = Math.floor((Math.random() * data.length) + 1);
    }
    return gemIndex;
  }

  function getGem(id) {
    return data[id];
  }

  function setGem(gem, id) {
    window.location.hash = id;
    $('.gem').html(fixedGem(gem));
    $('.linky').attr('href', '#' + id).text('Link this Gem!');
    // emojify.run();
  }

  function printGems() {
    for(var i = 0; i < data.length; i++) {
      $('#text').append('<p>' + fixedGem(data[i]) + '</p>');
      $('#text').css('background-color', '#fff').show();
    }
  }

  function fixedGem(gem) {
    return gem.replace(/\r?\\n/g, '<br>').replace(/(\")|(\\)|(\”)|(\“)/g, '').replace(/\&gt\;/g, '');
  }

  (function init() {
    if (data === null) {
      getData();
    } else {
      loader();
      window.onhashchange = loader;
    }
  })();

  function range(start, end) {
    var foo = [];
    for (var i = start; i <= end; i++) {
        foo.push(i);
    }
    return foo;
  }

  return {
    loader: loader,
    printGems: printGems
  };
})();
