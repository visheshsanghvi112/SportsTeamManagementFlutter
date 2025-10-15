'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "aaebba418f7102794aa972a0ea38215d",
"version.json": "ad8efed25548914c659d22469520d556",
"index.html": "8c77d292437a61679ca5af342cd62e34",
"/": "8c77d292437a61679ca5af342cd62e34",
"main.dart.js": "81fa8530759dcbb8eb3d144de83e9ae8",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "317a9a9c9f2efb9104336ceef2252dd6",
"assets/AssetManifest.json": "38581e4b91bdd4b9e6cf7ece05e703a8",
"assets/NOTICES": "226a2944bfe0cffb1d67f6bcb382c518",
"assets/FontManifest.json": "b8c3d0380c78a296911c391979a618ec",
"assets/AssetManifest.bin.json": "b2844181560b748af7133c33fcdfa6e2",
"assets/packages/flutter_neumorphic/fonts/NeumorphicIcons.ttf": "32be0c4c86773ba5c9f7791e69964585",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Free-Solid-900.otf": "e151d7a6f42f17e9ea335c91d07b3739",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Free-Regular-400.otf": "df86a1976d76bd04cf3fcaf5add2dd0f",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Brands-Regular-400.otf": "440da663f17184f21f007a3a2bf60f69",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "16cdf25dc47b42201d6673ae46c7148b",
"assets/fonts/MaterialIcons-Regular.otf": "deffd70fc15974f9d309c47b0f9c8422",
"assets/assets/team.png": "6ac56981ac1c4ff75b5e932c60b43a8d",
"assets/assets/dashboard.png": "d3d6774710ca5d2b02602b57d7fd5289",
"assets/assets/aboutus.png": "bbf4a158ed8d4c9f23c0a4ae2b7ee773",
"assets/assets/hsnc_logo.png": "a3391262469a791196b760e0b1e6bd6b",
"assets/assets/settings.png": "363b1b78b79987336cb274d0e5e0de05",
"assets/assets/jaihind.jpg": "4569eb91c5c86ddcf26b6856f32156fe",
"assets/assets/mithibai.png": "6d7b4904f54e291d5e9525a36646375f",
"assets/assets/Group%252012.svg": "322d1291ec087e8dd42d272871de8922",
"assets/assets/Layer_x0020_1.svg": "30eb739b66d5c64027c791d84f4f5e3b",
"assets/assets/instagram_icon.png": "15e6f5d790c70021c9db4dc77d60e528",
"assets/assets/Group.svg": "bc551419d04af1eb0adcb596c175c30d",
"assets/assets/btnNotifications.svg": "b6351e57641a88fe383d737c71a7128a",
"assets/assets/elphinstone.svg.png": "74367ab37d36129cfb94860e8339ec93",
"assets/assets/otp.png": "51830bd67926d07eaee7b61ac2791e58",
"assets/assets/events.png": "6fa45d0485d1f6da82209c52d5363a31",
"assets/assets/sportsday.jpg": "b278db489250ca2bcbb36aedbb5379bc",
"assets/assets/Battery.svg": "5d983881a15cafa7642e4cc9b9359ce4",
"assets/assets/iconfinder_calendar_115762%25201.svg": "c2539e5b240ea129bd47742fc606b82e",
"assets/assets/background.png": "839533381a02c9099108c2b467c6c59e",
"assets/assets/Group%25209.svg": "23848dd965eb3b9fe414e040e5716020",
"assets/assets/Cellular%2520Connection.svg": "289bb42bb2e3fe250b521990051efe42",
"assets/assets/login1.png": "7138a5020fc7d1658dbd68f27e13b1d4",
"assets/assets/logo.png": "fcf8056bb35c2707bfd8bb711de4dc24",
"assets/assets/finallogo.png": "ebbb6990c85c94b1fea0c7e0853b6283",
"assets/assets/Group%252086.svg": "2b60d62fd863f236290f277c9bd07126",
"assets/assets/img1.png": "64f5018be19f96d65c8874c69843302c",
"assets/assets/wilson.png": "8674c78ff16b4f036b2cd2fbb776be6f",
"assets/assets/xaviers.png": "64a6ec8281819960eaef3bd9fdf7df5b",
"assets/assets/iconfinder_1_Youtube_colored_svg_5296521%25201.svg": "ea05b6c5f13b443fcff02fc0f24d061b",
"assets/assets/lala.png": "f31fe5054fea7528f4f865c8594a7d59",
"assets/assets/welcome.png": "0d823d9ab2a6b38f7ba09583ea2118b3",
"assets/assets/hrlogo.png": "7abadf2c8ad33225eb2d03baa9bd3593",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
