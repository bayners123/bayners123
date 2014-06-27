// Init captioner

$(window).load(function() {
    $('.captionme img, img.captionme').captionjs({
        'class_name'      : 'captionjs', // Class name assigned to each <figure>
        'schema'          : true,        // Use schema.org markup (i.e., itemtype, itemprop)
        'mode'            : 'animated',   // default | stacked | animated | hide
        'debug_mode'      : true,       // Output debug info to the JS console
        'force_dimensions': false        // Force the dimensions in case they can't be detected (e.g., image is not yet painted to viewport)
    });
});


/*********************************
 * Code to allow active features *
 *********************************/
// alert('im here')

function getHTTPRequest()
{
    var httpRequest = false;
    if (window.XMLHttpRequest) { //Test for Firefox, Safari, Opera
        httpRequest = new XMLHttpRequest();
        if (httpRequest.overrideMimeType) {
            httpRequest.overrideMimeType('text/xml');
            // This can cause errors in javascript consoles
        }
    }
    else if (window.ActiveXObject) {  //Test for IE
        try {
            httpRequest = new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e) {
            try {
                httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch (e) {}
        }
    }
    return httpRequest;
}

function loadFile(url)
{
    var httpRequest = getHTTPRequest();
    httpRequest.onreadystatechange = function()
    {
        if (httpRequest.readyState == 4 )
        {
            if (httpRequest.status == 200 || window.location.href.indexOf("http") == -1)
            {
                return httpRequest.responseText;
            }
            return "";
        }
        return "";
    }

    httpRequest.open('GET', url, true);
    httpRequest.send('');
}

var randomImage_last_rnd = -1;
var randomImage_IMAGE_COUNT_FILENAME = "image_count.txt";
var randomImage_DEFAULT_IMAGE_TYPE = ".jpg";
function randomImage(image_count_dir_name, containerid, image_count_dir_path, image_type)
{
    if (image_type == undefined)
        image_type = randomImage_DEFAULT_IMAGE_TYPE;
    var url = image_count_dir_path + '/' + image_count_dir_name + '/' + randomImage_IMAGE_COUNT_FILENAME;
    var httpRequest = getHTTPRequest();
    httpRequest.onreadystatechange = function()
    {
        if (httpRequest.readyState == 4 )
        {
            if (httpRequest.status == 200 || window.location.href.indexOf("http") == -1)
            {
                var count = 1 * httpRequest.responseText;
                // Do nothing if file couldn't be loaded or no images are present
                if (count == "" || count == 0)
                    return "";
                // Generate different rnd from last time
                var rnd;
                do
                {
                    rnd = Math.floor(Math.random() * count + 1);
                }
                while (count != 1 && rnd == randomImage_last_rnd); // != 1 because a single image in a dir would cause infinite loop
                randomImage_last_rnd = rnd;
                document.getElementById(containerid).innerHTML =
                    '<img src="'
                    + image_count_dir_path + '/' + image_count_dir_name + '/' + rnd + image_count_dir_name + image_type
                    + '" border="0" alt="Pictures from the Goicoechea Group laboratory"></img>';
                //document.write ("<img src='images/welcomepage/top/"+rotophoto+"top.jpg' border='0' alt='Pictures from the Goicoechea Group laboratory'></img>");

                // Write image_count.txt file in each image dir with a count of the images
                // Read this in here with AJAX method and parse as int
            }
        }
    }

    httpRequest.open('GET', url, true);
    httpRequest.send('');
}

function scrolltoggle(obj) {
	var el = document.getElementById(obj);
	if ( el.style.display != 'block' ) {
		el.style.display = 'block';
                window.scroll(0,1000);
	}
	else {
		el.style.display = 'none';
                window.scroll(0,0);
	}
}

