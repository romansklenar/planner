// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Ajax.Responders.register({
	onCreate: function(){
		$('indicator').show();
	},
	onComplete: function() {
		if(Ajax.activeRequestCount == 0)
			$('indicator').hide();
	}
});


function Scroll(id,ms){
	this.obj=document.getElementById(id);
	this.rstr=zxcWWHS()[3];
	this.lst=zxcWWHS()[3];
	this.tsrt=this.obj.offsetTop;
	this.ms=ms||500;
	this.scroll();
}

Scroll.prototype.scroll=function(){
	var oop=this;
	if (this.lst!=zxcWWHS()[3]){
		this.obj.style.top=(zxcWWHS()[3] > this.tsrt ? zxcWWHS()[3] :this.tsrt)+'px';
		this.lst=zxcWWHS()[3];
	}
	setTimeout(function(){ oop.scroll(); },this.ms);
}

function zxcWWHS(){
	if (window.innerHeight) return [window.innerWidth-10,window.innerHeight-10,window.pageXOffset,window.pageYOffset];
	else if (document.documentElement.clientHeight) return [document.documentElement.clientWidth-10,document.documentElement.clientHeight-10,document.documentElement.scrollLeft,document.documentElement.scrollTop];
	return [document.body.clientWidth,document.body.clientHeight,document.body.scrollLeft,document.body.scrollTop];
}