function l --description 'alias ls -al'
	ls -al  $argv;
end

function x --description 'alias x=exit'
	exit  $argv;
end

function s --description 'alias s=git status'
	git status;
end

function gs --description 'alias gs=git status'
	git status;
end

function gst --description 'alias gst=git status'
	git status;
end

function ga --description 'alias ga=git add'
	git add $argv;
end

function co --description 'alias co=git checkout'
	git checkout $argv;
end

function gco --description 'alias go=git checkout'
	git checkout $argv;
end
