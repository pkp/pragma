# Pragma

An official theme for OJS 3.2+. 

## Installation
This theme can be installed through the **Plugin Gallery** in Open Journal Systems. If it's not available in the plugin gallery, you may need to update Open Journal Systems to a compatible version. The theme also can be installed manually by picking up and downloading the correspondent version from a [release page](https://github.com/pkp/pragma/releases).

### For developers
1. `git clone https://github.com/pkp/pragma.git`.
2. Move to the theme's root folder: `cd pragma`.
3. Make sure that [npm](https://www.npmjs.com/get-npm) and [Gulp](https://gulpjs.com/) are installed.
4. Resolve dependencies: `npm install`. Gulp config file is inside a theme root folder `gulpfile.js`.
5. To compile external SCSS, concatenate styles and minify: `gulp sass`. The result CSS path is `resources/dist/app.min.css`. The theme's own styles are compiled automatically by OJS's theme API.
6. To concatenate and minify javascript: `gulp scripts` and `gulp compress`. The result Javascript file path is `resources/dist/app.min.js`. Run `gulp watch` to view javascript changes inside `resources/js` folder in real time.
7. To compile and minify all at once: `gulp compileAll`.
8. Copy the plugin's folder to `plugins/themes` directory starting from the OJS installation root folder.
9. Login into the OJS admin dashboard, activate the plugin and enable the theme.

Note that the master branch may contain code that will not be shipped to the stable release.
