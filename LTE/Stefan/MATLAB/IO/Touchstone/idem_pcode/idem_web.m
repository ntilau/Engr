function idem_web(html_file,hrootfig);
%
%	idem_web(html_file,hrootfig)
%
% Opens the system browser and displays <html_file>.
% The full file path must be indicated in order to properly
% locate the file in the filesystem. Second argument is the
% handle of IdEM root figure. Used to locate the user-defined
% browser settings on unix platforms.
% In case of unix platform the LoadBrowserSettings function
% is used to get the command that launches the browser.
% In case of windows platform the browser is automatically
% loaded using file association rules.
%
% Note: this function is adapted from the Matlab equivalent WEB.
% Modifications:
%  - removed the case of internal Matlab browser
%  - removed MAC platform handling
%  - removed call to docopt, using LoadBrowserSettings for IdEM
%  - simplified handling for unix platforms
%  - For Windows platform, explorer.exe is used. No need for
%    LoadBrowserSettings, which is only called for unix platforms.
