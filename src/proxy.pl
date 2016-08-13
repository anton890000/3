#!/usr/bin/perl -Tw
use strict;

sub filename_hash {
    my $filename=shift;
    $filename =~ s/_/__/g;
    # $filename =~ s/\./_d/g;
    $filename =~ s/\//_s/g;
    $filename =~ s/\*/_a/g;
    $filename =~ s/\|/_p/g;
    $filename =~ s/\(/_l/g;
    $filename =~ s/\)/_r/g;
    $filename =~ s/\$/_d/g;
    $filename =~ s/ /_w/g;
    $filename =~ s/:/_c/g;
    $filename =~ s/\n//g;
    $filename = 'cache/' . $filename;
    return $filename;
}

sub image_cache {
    my $request=shift;
    my $response=shift;
    my $filect='>' . filename_hash($request->url());
    my $content=$response->content();
    my $contenttype=$response->headers()->content_type();
    #printf "Opening file: " . $filect . "\n";
    open FILE, $filect;
    print FILE $contenttype . "\n" . $content;
    close FILE;
}

sub cache_check {
    my $request=shift;
    my $response;
    my $filect=filename_hash($request->url());
    if(-e $filect) {
	my $content;
	my $contenttype;
	open FILE, $filect;
	$contenttype=<FILE>;
	chomp($contenttype);
	read FILE, $content, 52428800;
	close FILE;
	$response=HTTP::Response->new();
	$response->headers()->content_type($contenttype);
	$response->headers()->content_length(length($content));
	$response->content($content);
	$response->code(200); # Response OK
	return $response;
    }
    else {
	return 0; 
    }
}

sub blocklist_clear {
    my $content = shift;
    $content =~ s/<[^<>]*\/Ads\/Media\/[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*ads[^<>]*zdnet.com[^<>]*>//g;
    $content =~ s/<[^<>]*www.zdnet.com\/fcgi-bin\/becky\/js\/RGROUP[^<>]*>//g;

    $content =~ s/<[^<>]*click-through.pl[^<>]*>//g;
    $content =~ s/<[^<>]*images.zdnet.com\/adverts[^<>]*>//g;
    $content =~ s/<[^<>]*BannerAds[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/([^<>]*[-_.])?ads?[0-9]?(\/|[-_.][^<>]*|\.(gif|jpe?g))[^<>]*>//g;
    $content =~ s/<[^<>]*\/([^<>]*[-_.])?count(er)?(\.cgi|\.dll|\.exe|[?\/])[^<>]*>//g;
    $content =~ s/<[^<>]*\/(ng)?adclient\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*tribalfusion.com[^<>]*>//g;
    $content =~ s/<[^<>]*\/(plain|live|rotate)[-_.]?ads?\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/(sponsor|banner)s?[0-9]?\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*banner([-_]?[a-z0-9]+)?\.(gif|jpg)[^<>]*>//g;
    $content =~ s/<[^<>]*\/_?(plain|live)?ads?(-banners)?\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/abanners\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/ad(sdna_image|gifs?)\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/ad(server|stream|juggler)\.(cgi|pl|dll|exe)[^<>]*>//g;
    $content =~ s/<[^<>]*\/adbanners\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/adserver[^<>]*>//g;
    $content =~ s/<[^<>]*\/adstream\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*\/adv((er)?ts?|ertis(ing|ements?))?\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/anzei(gen)?\/?[^<>]*>//g;
    $content =~ s/<[^<>]*\/ban[-_]cgi\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/banner_?ads\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/banner_?anzeigen[^<>]*>//g;
    $content =~ s/<[^<>]*\/bannerimage\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/banners?\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/banners?\.cgi\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/cgi-bin\/centralad\/getimage[^<>]*>//g;
    $content =~ s/<[^<>]*\/images\/addver\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/images\/advert\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/images\/marketing\/[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/place-ads[^<>]*>//g;
    $content =~ s/<[^<>]*\/popupads\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/promobar[^<>]*[^<>]*>//g;
    $content =~ s/<[^<>]*\/publicite\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/randomads\/[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/reklama\/[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/reklame\/[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/reklaam\/[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/siteads\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/sponsor[^<>]*\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/sponsors?[0-9]?\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/ucbandeimg\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/werb\.[^<>]*[^<>]*>//g;
    $content =~ s/<[^<>]*\/werbebanner\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/werbung\/[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/adv\.[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/advert[0-9]+\.jpg[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*bann\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/Media\/Images\/Adds\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/_banner\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/ad_images\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/adgenius\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/adimages\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/ads\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/ads\\[^<>]*>//g;
    $content =~ s/<[^<>]*\/viewad\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/adserve\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/adverts\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/annonser?\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/bando\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/bannerad\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/bannerfarm\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/bin\/getimage.cgi\/...\?AD[^<>]*>//g;
    $content =~ s/<[^<>]*\/cgi-bin\/getimage.cgi\/....\?GROUP=[^<>]*>//g;
    $content =~ s/<[^<>]*\/cgi-bin\/nph-load[^<>]*>//g;
    $content =~ s/<[^<>]*\/cgi-bin\/webad.dll\/ad[^<>]*>//g;
    $content =~ s/<[^<>]*\/cwmail\/acc\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/cwmail\/amzn-bm1\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/db_area\/banrgifs\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/gif\/teasere\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/grafikk\/annonse\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/graphics\/defaultAd\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/grf\/annonif[^<>]*>//g;
    $content =~ s/<[^<>]*\/htmlad\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/image\.ng\/AdType[^<>]*>//g;
    $content =~ s/<[^<>]*\/image\.ng\/transactionID[^<>]*>//g;
    $content =~ s/<[^<>]*\/ip_img\/[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/marketpl\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/minibanners\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/netscapeworld\/nw-ad\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/promotions\/houseads\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/rotads\/ [^<>]*>//g;
    $content =~ s/<[^<>]*\/rotateads\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/rotations\/ [^<>]*>//g;
    $content =~ s/<[^<>]*\/torget\/jobline\/[^<>]*\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/viewad\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/werbung\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/worldnet\/ad\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*\/zhp\/auktion\/img\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/cgi-bin\/nph-adclick.exe\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/Image\/BannerAdvertising\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/ad-bin\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/adlib\/server\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*\/gsa_bs\/gsa_bs.cmdl[^<>]*>//g;
    $content =~ s/<[^<>]*\/autoads\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/anz\/pics\/[^<>]*>//g;
    $content =~ s/<[^<>]*cgi.tietovalta.fi[^<>]*>//g;
    $content =~ s/<[^<>]*keltaisetsivut.fi\/web\/img\/[^<>]*gif[^<>]*>//g;
    $content =~ s/<[^<>]*haku.net\/pics\/pana[^<>]*gif[^<>]*>//g;
    $content =~ s/<[^<>]*194.251.243.50\/cgi-bin\/banner[^<>]*>//g;
    $content =~ s/<[^<>]*www.dime.net\/ad[^<>]*>//g;
    $content =~ s/<[^<>]*www.iltalehti.fi\/ad[^<>]*>//g;
    $content =~ s/<[^<>]*www.iltalehti.fi\/ilmkuvat[^<>]*>//g;
    $content =~ s/<[^<>]*www.mtv3.fi\/mainoskuvat[^<>]*>//g;
    $content =~ s/<[^<>]*\/adfinity[^<>]*>//g;
    $content =~ s/<[^<>]*\/[?]adserv[^<>]*>//g;
    $content =~ s/<[^<>]*\/bizgrphx\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/smallad2\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/ana2ad\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/adimg\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*counter\.pl[^<>]*>//g;
    $content =~ s/<[^<>]*\/spin_html\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/images\/topics\/topicgimp\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*discovery.com\/[^<>]*banner_id[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*bannr\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*cruel.com\/images\/[^<>]*>//g;
    $content =~ s/<[^<>]*idrink.com\/frm_bottom.htm[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*pb_ihtml\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/ph-ad[^<>]*\.focalink\.com[^<>]*>//g;
    $content =~ s/<[^<>]*\/cgi-bin\/adjuggler[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*(ms)?backoff(ice)?[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*(\/ie4|\/ie3|msie|sqlbans|powrbybo|activex|backoffice|explorer|netnow|getpoint|ntbutton|hmlink)[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*activex[^<>]*(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*explorer?.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*freeie\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/ie_?(buttonlogo|static?|anim[^<>]*)?\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*ie_sm\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*msie(30)?\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*msnlogo\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*office97_ad1\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*pbbobansm\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*powrbybo\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*sqlbans\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*exc_ms\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*ie4get_animated\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*ie4_animated\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*n_iemap\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*ieget\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*logo_msnhm_[^<>]*.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*mcsp2\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*msn2\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*add_active\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*n_msnmap\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*Ad00\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*s_msn\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*addchannel\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*adddesktop\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/ns4\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/v3sban\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/?FPCreated\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/opera35\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/opera13\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/opera_b\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/ie_horiz\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/ie_logo\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/images\/na\/us\/brand\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/advantage\.(gif|jpg)[^<>]*>//g;
    $content =~ s/<[^<>]*\/advanbar\.(gif|jpg)[^<>]*>//g;
    $content =~ s/<[^<>]*\/advanbtn\.(gif|jpg)[^<>]*>//g;
    $content =~ s/<[^<>]*\/biznetsmall\.(gif|jpg)[^<>]*>//g;
    $content =~ s/<[^<>]*\/utopiad\.(gif|jpg)[^<>]*>//g;
    $content =~ s/<[^<>]*\/epipo\.(gif|jpg)[^<>]*>//g;
    $content =~ s/<[^<>]*\/amazon([a-zA-Z0-9]+)\.(gif|jpg)[^<>]*>//g;
    $content =~ s/<[^<>]*\/bnlogo.(gif|jpg)[^<>]*>//g;
    $content =~ s/<[^<>]*\/p\/d\/publicid[^<>]*>//g;
    $content =~ s/<[^<>]*\/Advertenties\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*.\/Adverteerders\/[^<>]*>//g;
    $content =~ s/<[^<>]*netdirect.nl\/nd_servlet\/___[^<>]*>//g;
    $content =~ s/<[^<>]*12.16.1.10\/web_GIF[^<>]*>//g;
    $content =~ s/<[^<>]*12.16.1.10\/~web_ani[^<>]*>//g;
    $content =~ s/<[^<>]*193.158.37.3\/cgi-bin\/impact[^<>]*>//g;
    $content =~ s/<[^<>]*193.210.156.114[^<>]*>//g;
    $content =~ s/<[^<>]*193.98.1.160\/img[^<>]*>//g;
    $content =~ s/<[^<>]*194.221.183.222\/mailsentlu[^<>]*>//g;
    $content =~ s/<[^<>]*194.221.183.223[^<>]*>//g;
    $content =~ s/<[^<>]*194.221.183.224[^<>]*>//g;
    $content =~ s/<[^<>]*194.221.183.225[^<>]*>//g;
    $content =~ s/<[^<>]*194.221.183.226[^<>]*>//g;
    $content =~ s/<[^<>]*194.221.183.227[^<>]*>//g;
    $content =~ s/<[^<>]*194.231.79.38[^<>]*>//g;
    $content =~ s/<[^<>]*195.124.124.56[^<>]*>//g;
    $content =~ s/<[^<>]*195.27.70.69[^<>]*>//g;
    $content =~ s/<[^<>]*195.30.94.21[^<>]*>//g;
    $content =~ s/<[^<>]*199.78.52.10[^<>]*>//g;
    $content =~ s/<[^<>]*1st-fuss.com[^<>]*>//g;
    $content =~ s/<[^<>]*204.253.46.71:1977[^<>]*>//g;
    $content =~ s/<[^<>]*204.94.67.40\/wc\/[^<>]*>//g;
    $content =~ s/<[^<>]*205.153.208.93[^<>]*>//g;
    $content =~ s/<[^<>]*205.216.163.62[^<>]*>//g;
    $content =~ s/<[^<>]*205.217.103.58:1977[^<>]*>//g;
    $content =~ s/<[^<>]*206.165.5.162\/images\/gcanim\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*206.221.254.181:80[^<>]*>//g;
    $content =~ s/<[^<>]*206.50.219.33[^<>]*>//g;
    $content =~ s/<[^<>]*207.137.96.35[^<>]*>//g;
    $content =~ s/<[^<>]*207.159.129.131\/abacus[^<>]*>//g;
    $content =~ s/<[^<>]*207.159.135.72[^<>]*>//g;
    $content =~ s/<[^<>]*207.82.250.9[^<>]*>//g;
    $content =~ s/<[^<>]*207.87.15.234[^<>]*>//g;
    $content =~ s/<[^<>]*207.87.27.10\/tool\/includes\/gifs\/[^<>]*>//g;
    $content =~ s/<[^<>]*208.156.39.142[^<>]*>//g;
    $content =~ s/<[^<>]*208.156.39.144[^<>]*>//g;
    $content =~ s/<[^<>]*208.156.60.230[^<>]*>//g;
    $content =~ s/<[^<>]*208.156.60.234[^<>]*>//g;
    $content =~ s/<[^<>]*208.156.60.235[^<>]*>//g;
    $content =~ s/<[^<>]*209.1.112.252\/adgraph\/[^<>]*>//g;
    $content =~ s/<[^<>]*209.1.135.142:1971[^<>]*>//g;
    $content =~ s/<[^<>]*209.1.135.144:1971[^<>]*>//g;
    $content =~ s/<[^<>]*209.132.97.164\/IMG\/[^<>]*>//g;
    $content =~ s/<[^<>]*209.185.222.45[^<>]*>//g;
    $content =~ s/<[^<>]*209.185.222.60[^<>]*>//g;
    $content =~ s/<[^<>]*209.207.224.220\/servfu.pl [^<>]*>//g;
    $content =~ s/<[^<>]*209.207.224.222\/servfu.pl[^<>]*>//g;
    $content =~ s/<[^<>]*209.239.37.214\/cgi-pilotfaq\/getimage\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*209.297.224.220[^<>]*>//g;
    $content =~ s/<[^<>]*209.75.21.6[^<>]*>//g;
    $content =~ s/<[^<>]*209.85.89.183\/cgi-bin\/cycle\?host[^<>]*>//g;
    $content =~ s/<[^<>]*212.63.155.122\/(banner|concret|softwareclub)[^<>]*>//g;
    $content =~ s/<[^<>]*216.15.157.34[^<>]*>//g;
    $content =~ s/<[^<>]*216.27.61.150[^<>]*>//g;
    $content =~ s/<[^<>]*216.49.10.236\/web1000\/[^<>]*>//g;
    $content =~ s/<[^<>]*247media.com[^<>]*>//g;
    $content =~ s/<[^<>]*62.144.115.12\/dk\/[^<>]*>//g;
    $content =~ s/<[^<>]*ICDirect.com\/cgi-bin[^<>]*>//g;
    $content =~ s/<[^<>]*Shannon.Austria.Eu.net\/\.cgi\/[^<>]*>//g;
    $content =~ s/<[^<>]*WebSiteSponsor.de[^<>]*>//g;
    $content =~ s/<[^<>]*207.181.220.145[^<>]*>//g;
    $content =~ s/<[^<>]*admaximize.com[^<>]*>//g;
    $content =~ s/<[^<>]*imgis.com[^<>]*>//g;
    $content =~ s/<[^<>]*preferences.com[^<>]*>//g;
    $content =~ s/<[^<>]*1ad.prolinks.de[^<>]*>//g;
    $content =~ s/<[^<>]*adwisdom.com[^<>]*>//g;
    $content =~ s/<[^<>]*altavista.telia.com\/av\/pix\/sponsors\/[^<>]*>//g;
    $content =~ s/<[^<>]*annonce.insite.dk[^<>]*>//g;
    $content =~ s/<[^<>]*asinglesplace.com\/asplink\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*athand.com\/rotation[^<>]*>//g;
    $content =~ s/<[^<>]*automatiseringgids.nl\/gfx\/advertenties\/[^<>]*>//g;
    $content =~ s/<[^<>]*avenuea.com\/view\/[^<>]*>//g;
    $content =~ s/<[^<>]*badservant.guj.de[^<>]*>//g;
    $content =~ s/<[^<>]*befriends.net\/personals\/matchmaking\.jpg[^<>]*>//g;
    $content =~ s/<[^<>]*bizad.nikkeibp.co.jp[^<>]*>//g;
    $content =~ s/<[^<>]*bs.gsanet.com\/gsa_bs\/[^<>]*>//g;
    $content =~ s/<[^<>]*cash-for-clicks.de[^<>]*>//g;
    $content =~ s/<[^<>]*cda.at\/customer\/[^<>]*>//g;
    $content =~ s/<[^<>]*cgicounter.puretec.de\/cgi-bin\/[^<>]*>//g;
    $content =~ s/<[^<>]*ciec.org\/images\/countdown\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*classic.adlink.de\/cgi-bin\/accipiter\/adserver.exe[^<>]*>//g;
    $content =~ s/<[^<>]*click..wisewire.com[^<>]*>//g;
    $content =~ s/<[^<>]*clickhere.egroups.com\/img\/[^<>]*>//g;
    $content =~ s/<[^<>]*imagine-inc.com[^<>]*>//g;
    $content =~ s/<[^<>]*commonwealth.riddler.com\/Commonwealth\/bin\/statdeploy\?[0-9]+[^<>]*>//g;
    $content =~ s/<[^<>]*customad.cnn.com[^<>]*>//g;
    $content =~ s/<[^<>]*dagbladet.no\/ann-gif[^<>]*>//g;
    $content =~ s/<[^<>]*deja.com\/jump\/[^<>]*>//g;
    $content =~ s/<[^<>]*digits.com\/wc\/[^<>]*>//g;
    $content =~ s/<[^<>]*dino.mainz.ibm.de[^<>]*>//g;
    $content =~ s/<[^<>]*dn.adzerver.com\/image.ad[^<>]*>//g;
    $content =~ s/<[^<>]*ds.austriaonline.at[^<>]*>//g;
    $content =~ s/<[^<>]*emap.admedia.net[^<>]*>//g;
    $content =~ s/<[^<>]*etrade.com\/promo\/[^<>]*>//g;
    $content =~ s/<[^<>]*eur.yimg.com\/a\/[^<>]*>//g;
    $content =~ s/<[^<>]*eurosponsor.de[^<>]*>//g;
    $content =~ s/<[^<>]*fastcounter.linkexchange.com[^<>]*>//g;
    $content =~ s/<[^<>]*flycast.com[^<>]*>//g;
    $content =~ s/<[^<>]*focalink.com\/SmartBanner[^<>]*>//g;
    $content =~ s/<[^<>]*freepage.de\/cgi-bin\/feets\/freepage_ext\/[^<>]*\/rw_banner[^<>]*>//g;
    $content =~ s/<[^<>]*freespace.virgin.net\/andy.drake[^<>]*>//g;
    $content =~ s/<[^<>]*futurecard.com\/images\/[^<>]*>//g;
    $content =~ s/<[^<>]*gaia.occ.com\/click[^<>]*[^<>]*>//g;
    $content =~ s/<[^<>]*globaltrack.com[^<>]*>//g;
    $content =~ s/<[^<>]*globaltrak.net[^<>]*>//g;
    $content =~ s/<[^<>]*go.com\/cimages\?SEEK_[^<>]*>//g;
    $content =~ s/<[^<>]*gp.dejanews.com\/gtplacer[^<>]*>//g;
    $content =~ s/<[^<>]*gtp.dejanews.com\/gtplacer[^<>]*>//g;
    $content =~ s/<[^<>]*deja.com\/gifs\/onsale\/[^<>]*>//g;
    $content =~ s/<[^<>]*hitbox.com [^<>]*>//g;
    $content =~ s/<[^<>]*home.miningco.com\/event.ng\/[^<>]*AdID[^<>]*>//g;
    $content =~ s/<[^<>]*hurra.de[^<>]*>//g;
    $content =~ s/<[^<>]*hyperbanner.net[^<>]*>//g;
    $content =~ s/<[^<>]*icount.com\/[^<>]*count[^<>]*>//g;
    $content =~ s/<[^<>]*image.narrative.com\/news\/[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*image.click2net.com[^<>]*>//g;
    $content =~ s/<[^<>]*image.linkexchange.com[^<>]*>//g;
    $content =~ s/<[^<>]*images.nytimes.com[^<>]*>//g;
    $content =~ s/<[^<>]*images.yahoo.com\/adv\/[^<>]*>//g;
    $content =~ s/<[^<>]*images.yahoo.com\/promotions\/[^<>]*>//g;
    $content =~ s/<[^<>]*imageserv.adtech.de[^<>]*>//g;
    $content =~ s/<[^<>]*img.web.de[^<>]*>//g;
    $content =~ s/<[^<>]*impartner.de\/cgi-bin[^<>]*>//g;
    $content =~ s/<[^<>]*informer2.comdirect.de:6004\/cd\/banner2[^<>]*>//g;
    $content =~ s/<[^<>]*infoseek.go.com\/cimages[^<>]*>//g;
    $content =~ s/<[^<>]*ins.at\/asp\/images\/[^<>]*>//g;
    $content =~ s/<[^<>]*kaufwas.com\/cgi-bin\/zentralbanner\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*leader.linkexchange.com[^<>]*>//g;
    $content =~ s/<[^<>]*link4ads.com[^<>]*>//g;
    $content =~ s/<[^<>]*link4link.com[^<>]*>//g;
    $content =~ s/<[^<>]*linktrader.com\/cgi-bin\/[^<>]*>//g;
    $content =~ s/<[^<>]*logiclink.nl\/cgi-bin\/[^<>]*>//g;
    $content =~ s/<[^<>]*lucky.theonion.com\/cgi-bin\/oniondirectin\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*lucky.theonion.com\/cgi-bin\/onionimp\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*lucky.theonion.com\/cgi-bin\/onionimpin\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*doubleclick.net[^<>]*>//g;
    $content =~ s/<[^<>]*mailorderbrides.com\/mlbrd2\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*media.priceline.com[^<>]*>//g;
    $content =~ s/<[^<>]*mediaplex.com[^<>]*>//g;
    $content =~ s/<[^<>]*members.sexroulette.com[^<>]*>//g;
    $content =~ s/<[^<>]*messenger.netscape.com[^<>]*>//g;
    $content =~ s/<[^<>]*miningco.com\/zadz\/[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*banner[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*newbutton[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*ad\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*mmail[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*poster\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*btyb[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*h_guy[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*h_showtick[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*h_aML[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*\/m_[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*\/icon_[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*\/NF_[^<>]*back[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/[^<>]*\/h_[^<>]*gif[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/media\/imagelinks[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/media\/imagelinks\/MF.(ad|sponsor)[^<>]*>//g;
    $content =~ s/<[^<>]*moviefone.com\/media\/art[^<>]*>//g;
    $content =~ s/<[^<>]*mqgraphics.mapquest.com\/graphics\/Advertisements\/[^<>]*>//g;
    $content =~ s/<[^<>]*netgravity[^<>]*[^<>]*>//g;
    $content =~ s/<[^<>]*newads.cmpnet.com[^<>]*>//g;
    $content =~ s/<[^<>]*news.com\/cgi-bin\/acc_clickthru[^<>]*>//g;
    $content =~ s/<[^<>]*ngadcenter.net[^<>]*>//g;
    $content =~ s/<[^<>]*ngserve.pcworld.com\/adgifs\/[^<>]*>//g;
    $content =~ s/<[^<>]*nol.at:81[^<>]*>//g;
    $content =~ s/<[^<>]*nrsite.com[^<>]*>//g;
    $content =~ s/<[^<>]*nytsyn.com\/gifs[^<>]*>//g;
    $content =~ s/<[^<>]*offers.egroups.com[^<>]*>//g;
    $content =~ s/<[^<>]*pagecount.com[^<>]*>//g;
    $content =~ s/<[^<>]*ph-ad[^<>]*\.focalink.com[^<>]*>//g;
    $content =~ s/<[^<>]*preferences.com[^<>]*>//g;
    $content =~ s/<[^<>]*promotions.yahoo.com\/[^<>]*>//g;
    $content =~ s/<[^<>]*pub.nomade.fr[^<>]*>//g;
    $content =~ s/<[^<>]*qsound.com\/tracker\/tracker.exe[^<>]*>//g;
    $content =~ s/<[^<>]*resource-marketing.com\/tb\/[^<>]*>//g;
    $content =~ s/<[^<>]*revenue.infi.net[^<>]*>//g;
    $content =~ s/<[^<>]*rtl.de\/homepage\/wb\/images\/[^<>]*>//g;
    $content =~ s/<[^<>]*schnellsuche.de\/images\/[^<>]*>//g;
    $content =~ s/<[^<>]*shout-ads.com\/cgibin\/shout.php3[^<>]*>//g;
    $content =~ s/<[^<>]*sjmercury.com\/advert\/[^<>]*>//g;
    $content =~ s/<[^<>]*smartclicks.com\/[^<>]*\/smart(img|banner|host|bar|site)[^<>]*>//g;
    $content =~ s/<[^<>]*smh.com.au\/adproof\/[^<>]*>//g;
    $content =~ s/<[^<>]*spinbox1.filez.com[^<>]*>//g;
    $content =~ s/<[^<>]*static.wired.com\/advertising\/[^<>]*>//g;
    $content =~ s/<[^<>]*swiftad.com[^<>]*>//g;
    $content =~ s/<[^<>]*sysdoc.pair.com\/cgi-sys\/cgiwrap\/sysdoc\/sponsor\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*t-online.de\/home\/040255162-001\/[^<>]*>//g;
    $content =~ s/<[^<>]*taz.de\/taz\/anz\/[^<>]*>//g;
    $content =~ s/<[^<>]*tcsads.tcs.co.at[^<>]*>//g;
    $content =~ s/<[^<>]*teleauskunft.de\/commercial\/[^<>]*>//g;
    $content =~ s/<[^<>]*thecounter.com\/id[^<>]*>//g;
    $content =~ s/<[^<>]*tm.intervu.net[^<>]*>//g;
    $content =~ s/<[^<>]*tvguide.com\/rbitmaps\/[^<>]*>//g;
    $content =~ s/<[^<>]*ubl.com\/graphics\/[^<>]*>//g;
    $content =~ s/<[^<>]*ubl.com\/images\/[^<>]*>//g;
    $content =~ s/<[^<>]*ultra.multimania.com[^<>]*>//g;
    $content =~ s/<[^<>]*ultra1.socomm.net[^<>]*>//g;
    $content =~ s/<[^<>]*uproar.com[^<>]*>//g;
    $content =~ s/<[^<>]*us.yimg.com\/a\/[^<>]*>//g;
    $content =~ s/<[^<>]*us.yimg.com\/promotions\/[^<>]*>//g;
    $content =~ s/<[^<>]*valueclick.com[^<>]*>//g;
    $content =~ s/<[^<>]*valueclick.net[^<>]*>//g;
    $content =~ s/<[^<>]*victory.cnn.com[^<>]*>//g;
    $content =~ s/<[^<>]*videoserver.kpix.com[^<>]*>//g;
    $content =~ s/<[^<>]*washingtonpost.com\/wp-adv\/[^<>]*>//g;
    $content =~ s/<[^<>]*webconnect.net\/cgi-bin\/webconnect.dll[^<>]*>//g;
    $content =~ s/<[^<>]*webcounter.goweb.de[^<>]*>//g;
    $content =~ s/<[^<>]*webserv.vnunet.com\/ip_img\/[^<>]*ban[^<>]*>//g;
    $content =~ s/<[^<>]*werbung.pro-sieben.de\/cgi-bin[^<>]*>//g;
    $content =~ s/<[^<>]*whatis.com\/cgi-bin\/getimage.exe\/[^<>]*>//g;
    $content =~ s/<[^<>]*www..bigyellow.com\/......mat[^<>]*[^<>]*>//g;
    $content =~ s/<[^<>]*www.adclub.net[^<>]*>//g;
    $content =~ s/<[^<>]*www.addme.com\/link8\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.aftonbladet.se\/annons[^<>]*>//g;
    $content =~ s/<[^<>]*www.americanpassage.com\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.angelfire.com\/in\/twistriot\/images\/wish4\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.bizlink.ru\/cgi-bin\/irads\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*www.blacklightmedia.com\/adlemur[^<>]*>//g;
    $content =~ s/<[^<>]*www.bluesnews.com\/flameq\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.bluesnews.com\/images\/ad[0-9]+\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.bluesnews.com\/images\/gcanim3\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.bluesnews.com\/images\/throbber2\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.bluesnews.com\/miscimages\/fragbutton\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.businessweek.com\/sponsors\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.canoe.ca\/AdsCanoe\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.cdnow.com\/MN\/client.banners[^<>]*>//g;
    $content =~ s/<[^<>]*www.clickagents.com[^<>]*>//g;
    $content =~ s/<[^<>]*www.clickthrough.ca[^<>]*>//g;
    $content =~ s/<[^<>]*www.clicmoi.com\/cgi-bin\/pub\.exe[^<>]*>//g;
    $content =~ s/<[^<>]*www.dailycal.org\/graphics\/adbanner-ab\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.detelefoongids.com\/pic\/[0-9]*[^<>]*>//g;
    $content =~ s/<[^<>]*www.dhd.de\/CGI\/werbepic[^<>]*>//g;
    $content =~ s/<[^<>]*www.dsf.de\/cgi-bin\/site_newiac.adpos[^<>]*>//g;
    $content =~ s/<[^<>]*www.firsttarget.com\/cgi-bin\/klicklog.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*www.forbes.com\/forbes\/gifs\/ads[^<>]*>//g;
    $content =~ s/<[^<>]*www.forbes.com\/tool\/includes\/gifs\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.fxweb.holowww.com\/[^<>]*\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*www.geocities.com\/TimesSquare\/Zone\/5267\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.goto.com\/images-promoters\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.handelsblatt.de\/hbad[^<>]*>//g;
    $content =~ s/<[^<>]*www.hotlinks.de\/cgi-bin\/barimage\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*www.infoseek.com\/cimages[^<>]*>//g;
    $content =~ s/<[^<>]*www.infoworld.com\/pageone\/gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.isys.net\/customer\/images[^<>]*>//g;
    $content =~ s/<[^<>]*www.javaworld.com\/javaworld\/jw-ad[^<>]*>//g;
    $content =~ s/<[^<>]*www.kron.com\/place-ads\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.leo.org\/leoclick\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.linkexchange.ru\/cgi-bin\/erle\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*www.linkstation.de\/cgi-bin\/zeige[^<>]*>//g;
    $content =~ s/<[^<>]*www.linux.org\/graphic\/miniature\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.linux.org\/graphic\/square\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.linux.org\/graphic\/standard\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.luncha.se\/annonsering[^<>]*>//g;
    $content =~ s/<[^<>]*www.mediashower.com[^<>]*>//g;
    $content =~ s/<[^<>]*www.ml.org\/gfx\/spon\/icom\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.ml.org\/gfx\/spon\/wmv[^<>]*>//g;
    $content =~ s/<[^<>]*www.musicblvd.com\/mb2\/graphics\/netgravity\/[^<>]*>//g;
    $content =~ s/<[^<>]*nedstat.nl\/cgi-bin\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.news.com\/Midas\/Images\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.newscientist.com\/houseads[^<>]*>//g;
    $content =~ s/<[^<>]*www.nextcard.com\/affiliates\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.nikkeibp.asiabiztech.com\/image\/NAIS4\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.oanda.com\/server\/banner[^<>]*>//g;
    $content =~ s/<[^<>]*omdispatch.co.uk[^<>]*>//g;
    $content =~ s/<[^<>]*www.oneandonlynetwork.com[^<>]*>//g;
    $content =~ s/<[^<>]*www.page2page.de\/cgi-bin\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.prnet.de\/[^<>]*\/bannerschnippel\/[^<>]*\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*www.promptsoftware.com\/marketing\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.reklama.ru\/cgi-bin\/banners\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.riddler.com\/sponsors\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.rle.ru\/cgi-bin\/erle\.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*www.rock.com\/images\/affiliates\/search_black\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.rtl.de\/search\/[^<>]*kunde[^<>]*>//g;
    $content =~ s/<[^<>]*www.search.com\/Banners[^<>]*>//g;
    $content =~ s/<[^<>]*www.sfgate.com\/place-ads\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.shareware.com\/midas\/images\/borders-btn\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.sjmercury.com\/products\/marcom\/banners\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.smartclicks.com:81[^<>]*>//g;
    $content =~ s/<[^<>]*www.sol.dk\/graphics\/portalmenu[^<>]*>//g;
    $content =~ s/<[^<>]*www.sponsornetz.de\/jump\/show.exe[^<>]*>//g;
    $content =~ s/<[^<>]*www.sponsorpool.net[^<>]*>//g;
    $content =~ s/<[^<>]*www.sunworld.com\/sunworldonline\/icons\/adinfo.sm\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.swwwap.com\/cgi-bin\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.taz.de\/~taz\/anz\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.telecom.at\/icons\/[^<>]*film\.(gif|jpe?g)[^<>]*>//g;
    $content =~ s/<[^<>]*www.theonion.com\/bin\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.topsponsor.de\/cgi-bin\/show.exe[^<>]*>//g;
    $content =~ s/<[^<>]*www.ugo.net[^<>]*>//g;
    $content =~ s/<[^<>]*www.ugu.com\/images\/EJ\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.warzone.com\/pics\/banner\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.warzone.com\/wzfb\/ads.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*www.webpeep.com[^<>]*>//g;
    $content =~ s/<[^<>]*www.websitepromote.com\/partner\/img\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.winjey.com\/onlinewerbung\/[^<>]*\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.wishing.com\/webaudit[^<>]*>//g;
    $content =~ s/<[^<>]*www.www-pool.de\/cgi-bin\/banner-pool[^<>]*>//g;
    $content =~ s/<[^<>]*www2.blol.com\/agrJRU\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www3.exn.net:80[^<>]*>//g;
    $content =~ s/<[^<>]*yahoo.com\/CategoryID=0[^<>]*>//g;
    $content =~ s/<[^<>]*yahoo.de\/adv\/images[^<>]*>//g;
    $content =~ s/<[^<>]*~cpan.valueclick.com[^<>]*>//g;
    $content =~ s/<[^<>]*~www.hitbox.com[^<>]*>//g;
    $content =~ s/<[^<>]*www.bannerland.de\/click.exe[^<>]*>//g;
    $content =~ s/<[^<>]*cyberclick.net[^<>]*>//g;
    $content =~ s/<[^<>]*eu-adcenter.net\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.web-stat.com[^<>]*>//g;
    $content =~ s/<[^<>]*www.slate.com\/snav\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.slate.com\/redirect\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.slate.com\/articleimages\/[^<>]*>//g;
    $content =~ s/<[^<>]*usads.imdb.com[^<>]*>//g;
    $content =~ s/<[^<>]*www.forbes.com\/tool\/images\/frontend\/[^<>]*>//g;
$content =~ s/<[^<>]*www.zserver.com[^<>]*>//g;
    $content =~ s/<[^<>]*www.spinbox.com[^<>]*>//g;
    $content =~ s/<[^<>]*pathfinder.com\/shopping\/marketplace\/images\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/adbanner[^<>]*>//g;
    $content =~ s/<[^<>]*\/adgraphic[^<>]*>//g;
    $content =~ s/<[^<>]*static.wired.com\/images[^<>]*>//g;
    $content =~ s/<[^<>]*perso.estat.com\/cgi-bin\/perso\/[^<>]*>//g;
    $content =~ s/<[^<>]*dinoadserver1.roka.net[^<>]*>//g;
    $content =~ s/<[^<>]*fooladclient.fool.com[^<>]*>//g;
    $content =~ s/<[^<>]*affiliate.aol.com\/static\/[^<>]*>//g;
    $content =~ s/<[^<>]*cybereps.com:8000[^<>]*>//g;
    $content =~ s/<[^<>]*iadnet.com[^<>]*>//g;
    $content =~ s/<[^<>]*orientserve.com[^<>]*>//g;
    $content =~ s/<[^<>]*wvolante.com[^<>]*>//g;
    $content =~ s/<[^<>]*findcommerce.com[^<>]*>//g;
    $content =~ s/<[^<>]*smartage.com[^<>]*>//g;
    $content =~ s/<[^<>]*germany.net\/gebu-frei\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*germany.net\/bilder\/menue\/leiste\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*germany.net\/bilder\/gn_logos\/[^<>]*>//g;
    $content =~ s/<[^<>]*germany.net\/bilder\/90x90\/[^<>]*>//g;
    $content =~ s/<[^<>]*germany.net\/banner-homepage\/[^<>]*>//g;
    $content =~ s/<[^<>]*germany.net\/downloadshop\/[^<>]*>//g;
    $content =~ s/<[^<>]*germany.net\/bilder\/action\/promopoly\/germanynet\/basisdienste\/hilfe\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.geocities.com\/ad_container\/pop.html[^<>]*>//g;
    $content =~ s/<[^<>]*img.getstats.com\/[^<>]*>//g;
    $content =~ s/<[^<>]*ads.xmonitor.net\/xadengine.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*v3.come.to\/pop.asp[^<>]*>//g;
    $content =~ s/<[^<>]*home.talkcity.com\/homepopup.html[^<>]*>//g;
    $content =~ s/<[^<>]*banner.freeservers.com\/cgi-bin\/fs_adbar[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/?va_banner.html[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/advert[0-9]+\.jpg[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*\/ie_horiz\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*mircx.com\/images\/buttons\/[^<>]*>//g;
    $content =~ s/<[^<>]*services.mircx.com\/[^<>]*\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.userfriendly.org\/images\/banners\/banner_dp_heart\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.easyspace.com\/(fpub)?banner.html[^<>]*>//g;
    $content =~ s/<[^<>]*www.easyspace.com\/100\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*banner.ricor.ru\/cgi-bin\/banner.pl[^<>]*>//g;
    $content =~ s/<[^<>]*www.bizlink.ru\/cgi-bin\/irads.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*stx9.sextracker.com\/stx\/send\/[^<>]*>//g;
    $content =~ s/<[^<>]*angelfire.com\/sys\/download.html[^<>]*>//g;
    $content =~ s/<[^<>]*sally.songline.com\/[^<>]*>//g;
    $content =~ s/<[^<>]*images.eule.de\/comdirect\.gif [^<>]*>//g;
    $content =~ s/<[^<>]*images.eule.de\/wp\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*aladin.de\/125_1\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*images.eule.de\/neu\/books\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*cnnstore\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*book.search\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*cnnpostopinionhome.\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*custom_feature\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*explore.anim[^<>]*gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*infoseek\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*pathnet.warner\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*images\/cnnfn_infoseek\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*images\/pathfinder_btn2\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*img\/gen\/fosz_front_em_abc\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*img\/promos\/bnsearch\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/[^<>]*navbars\/nav_partner_logos\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/digitaljam\/images\/digital_ban\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/hotstories\/companies\/images\/companies_banner\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/markets\/images\/markets_banner\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/ows-img\/bnoble\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/ows-img\/nb_Infoseek\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*cnn.com\/images\/custom\/totale\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*cnn.com\/images\/lotd\/custom.wheels\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*cnn.com\/images\/[^<>]*\/by\/main.12\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*cnn.com\/images\/[^<>]*\/find115\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*cnn.com\/[^<>]*\/free.email.120\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*cnnfn.com\/images\/left_banner\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*focus.de\/A\/AF\/AFL\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.cnn.com\/images\/[^<>]*\/bn\/books\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.cnn.com\/images\/[^<>]*\/pointcast\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.cnn.com\/images\/[^<>]*\/fusa\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*cnn.com\/images\/[^<>]*\/start120\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*images.cnn.com\/SHOP\/[^<>]*>//g;
    $content =~ s/<[^<>]*g.deja.com\/gifs\/(q|us)west_120x120\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/gif\/buttons\/banner_[^<>]*[^<>]*>//g;
    $content =~ s/<[^<>]*\/gif\/buttons\/cd_shop_[^<>]*[^<>]*>//g;
    $content =~ s/<[^<>]*\/gif\/cd_shop\/cd_shop_ani_[^<>]*[^<>]*>//g;
    $content =~ s/<[^<>]*\/av\/gifs\/av_map\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/av\/gifs\/av_logo\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/av\/gifs\/new\/ns\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*altavista.com\/i\/valsdc3\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*jump.altavista.com\/gn_sf[^<>]*>//g;
    $content =~ s/<[^<>]*tucows[^<>\/]*[^<>\/]*\/images\/locallogo\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*mt_freshmeat\.jpg[^<>]*>//g;
    $content =~ s/<[^<>]*go2net.com\/mgic\/adpopup[^<>]*>//g;
    $content =~ s/<[^<>]*go2net.com\/metaspy\/images\/exposed\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*go2net.com\/metaspy\/images\/ms_un\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.cebu-usa.com\/cwbanim1\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.cebu-usa.com\/Connection\.jpg[^<>]*>//g;
    $content =~ s/<[^<>]*www.cebu-usa.com\/phonead\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.cebu-usa.com\/ban3\.jpg[^<>]*>//g;
    $content =~ s/<[^<>]*www.cebu-usa.com\/tlban\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.cebu-usa.com\/apwlogo1\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.cebu-usa.com\/rose\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.fnet.de\/img\/geldboerselogo\.jpg[^<>]*>//g;
    $content =~ s/<[^<>]*www.assalom.com\/aziza\/logos\/cniaffil\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.assalom.com\/aziza\/logos\/4starrl1\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.phantomstar.com\/images\/media\/m1\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*wahlstreet.de\/MediaW\$\/tsponline\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*wahlstreet.de\/MediaW\$\/dzii156x60\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*wahlstreet.de\/MediaW\$\/etban156x60_2_opt2\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/pics\/gotlx1\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/pics\/getareal1\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/pics\/amzn-b5\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/ltbs\/cgi-bin\/click.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*linuxtoday.com\/ltbs\/pics\/[^<>]*>//g;
    $content =~ s/<[^<>]*# Geocities popups[^<>]*>//g;
    $content =~ s/<[^<>]*\/ad[-_]container\/[^<>]*>//g;
    $content =~ s/<[^<>]*\/include\/watermark\/v2\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.freeyellow.com\/images\/powerlink5a\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.freeyellow.com\/images\/powerlink5b\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.freeyellow.com\/images\/powerlink5c\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.freeyellow.com\/images\/powerlink5d\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.freeyellow.com\/images\/powerlink5e\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.eads.com\/images\/refbutton\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.fortunecity.com\/console2\/newnav\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.goldetc.net\/search\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.cris.com\/~Lzrdking\/carpix\/cars3-le\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.justfreestuff.com\/scott\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.cyberthrill.com\/entrance\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*secure.pec.net\/images\/pec69ani\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.new-direction.com\/avviva\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*internetmarketingcenter\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.new-direction.com\/wp-linkexchange-loop\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.new-direction.com\/windough\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.digitalwork.com\/universal_images\/affiliate\/dw_le_3\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*service.bfast.com\/bfast\/click\/[^<>]*>//g;
    $content =~ s/<[^<>]*www.new-direction.com\/magiclearning\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.new-direction.com\/mailloop\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.free-banners.com\/images\/hitslogo\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*rob.simplenet.com\/dyndns\/fortune5\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*nasdaq-amex.com\/images\/bn_ticker\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*a[^<>]*.yimg.com\/([0-9]*|\/)*us.yimg.com\/[^<>]*>//g;
    $content =~ s/<[^<>]*ad.doubleclick.net[^<>]*>//g;
    $content =~ s/<[^<>]*www.dnps.com\/ads[^<>]*>//g;
    $content =~ s/<[^<>]*www.realtop50.com\/cgi-bin\/ad[^<>]*>//g;
    $content =~ s/<[^<>]*www.yacht.de\/images\/(my_ani|eissingani|chartertrans|fum|schnupper|fysshop|garmin)\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.sponsorweb.de\/web-sponsor\/nt-bin\/show.exe[^<>]*>//g;
    $content =~ s/<[^<>]*gmx.net\/images\/newsbanner\/[^<>]*>//g;
    $content =~ s/<[^<>]*cash4banner.de[^<>]*>//g;
    $content =~ s/<[^<>]*quicken.lexware.de\/images\/us7-468x60.gif[^<>]*>//g;
    $content =~ s/<[^<>]*\/img\/special\/chatpromo\.gif[^<>]*>//g;
    $content =~ s/<[^<>]*www.travelocity.com\/images\/promos\/[^<>]*>//g;
    $content =~ s/<[^<>]*p01.com\/1x1.dyn[^<>]*>//g;
    $content =~ s/<[^<>]*\/phpAds\/viewbanner.php[^<>]*>//g;
    $content =~ s/<[^<>]*\/phpAds\/phpads.php[^<>]*>//g;
    $content =~ s/<[^<>]*www.linux-magazin.de\/banner    [^<>]*>//g;
    $content =~ s/<[^<>]*comtrack.comclick.com[^<>]*>//g;
    $content =~ s/<[^<>]*click-fr.com[^<>]*>//g;
    $content =~ s/<[^<>]*iac-online.de\/filler[^<>]*>//g;
    $content =~ s/<[^<>]*media.interadnet.com[^<>]*>//g;
    $content =~ s/<[^<>]*stat.www.fi\/cgi-bin[^<>]*>//g;
    $content =~ s/<[^<>]*\/cgi\/banners.cgi[^<>]*>//g;
    $content =~ s/<[^<>]*ads-digi.sol.no[^<>]*>//g;
    $content =~ s/<[^<>]*fp.buy.com[^<>]*>//g;
    $content =~ s/<[^<>]*disneystoreaffiliates.com[^<>]*>//g;
    $content;
}




## Copyright (c) 1996 by Randal L. Schwartz, Piotr F. Mitros
## This program is free software; you can redistribute it
## and/or modify it under the same terms as Perl itself.

## Anonymous HTTP proxy (handles http:, gopher:, ftp:)
## requires LWP 5.04 or later

my $HOST = "localhost";
my $PORT = "9000";

sub prefix {
  my $now = localtime;

  join "", map { "[$now] [${$}] $_\n" } split /\n/, join "", @_;
}

$SIG{__WARN__} = sub { warn prefix @_ };
$SIG{__DIE__} = sub { die prefix @_ };
$SIG{CLD} = $SIG{CHLD} = sub { wait; };

my $AGENT;                      # global user agent (for efficiency)
BEGIN {
  use LWP::UserAgent;

  @MyAgent::ISA = qw(LWP::UserAgent); # set inheritance

  $AGENT = MyAgent->new;
  $AGENT->agent("anon/0.07");
  $AGENT->env_proxy;
}

sub MyAgent::redirect_ok { 0 } # redirects should pass through

{                               ### MAIN ###
  use HTTP::Daemon;

  my $master = new HTTP::Daemon
    LocalAddr => $HOST, LocalPort => $PORT;
  warn "set your proxy to <URL:", $master->url, ">";
  my $slave;
  &handle_connection($slave) while $slave = $master->accept;
  exit 0;
}                               ### END MAIN ###

sub handle_connection {
  my $connection = shift;       # HTTP::Daemon::ClientConn

  my $pid = fork;
  if ($pid) {                   # spawn OK, and I'm the parent
    close $connection;
    return;
  }
  ## spawn failed, or I'm a good child
  my $request = $connection->get_request;
  if (defined($request)) {
    my $response = &fetch_request($request);
    $connection->send_response($response);
    close $connection;
  }
  exit 0 if defined $pid;       # exit if I'm a good child with a good parent
}

sub fetch_request {
  my $request = shift;          # HTTP::Request

  use HTTP::Response;

  my $url = $request->url;
  warn "fetching $url";
  if ($url->scheme !~ /^(http|gopher|ftp)$/) {
    my $res = HTTP::Response->new(403, "Forbidden");
    $res->content("bad scheme: @{[$url->scheme]}\n");
    $res;
  } elsif (not $url->rel->netloc) {
    my $res = HTTP::Response->new(403, "Forbidden");
    $res->content("relative URL not permitted\n");
    $res;
  } else {
    &fetch_validated_request($request);
  }
}

sub min {
    my $x=shift;
    my $y=shift;
    if ($y>$x) {
	$x;
    }
    else {
	$y;
    }
}

sub max {
    my $x=shift;
    my $y=shift;
    if ($y>$x) {
	$y;
    }
    else {
	$x;
    }
}

sub negg_parse_content {
    my $content = shift;
    my $line = "";
    my $x=0;
    my $y=0;
    my @lines;
    my @matrix;
    @lines = split("\n", $content);
    foreach $line (@lines) {
	if($line eq "<tr bgcolor='white'>") {
	    $y++; $x=0;
	}
	if($line =~ /td align=center width=30 height=30/) {
	    if($line =~ /nbsp/) {
		$matrix[$x++][$y]=" ";
	    }
	    elsif($line =~ /gn.gif/) {
		$matrix[$x++][$y]="Q";
	    }
	    elsif($line =~ /flagnegg/) {
		$matrix[$x++][$y]="X";
	    }
	    elsif($line =~ /badnegg/) {
		return 0;
	    }
	    else {
		$line =~ s/.*b.(.)..b.*/$1/;
		$matrix[$x++][$y]=$line;
	    }
	}
    }
    $x--;
    if($x != $y) {
	return 0;
    }
    else {
	my $x2;
	my $y2;
	for $y2 (0 .. $y) {
	    for $x2 (0 .. $x) {
		print $matrix[$x2][$y2];
	    }
	    print "\n";
	}

	for $y2 (0 .. $y) {
	    for $x2 (0 .. $x) {
		if($matrix[$x2][$y2] =~ /[123456789]/) {
		    my $xx=0;
		    my $qq=0;
		    my $x3=0;
		    my $y3=0;
		    for $y3 (max(0, $y2-1) .. min($y, $y2+1)) {
			for $x3 (max(0, $x2-1) .. min($x, $x2+1)) {
			    if($matrix[$x3][$y3] eq 'X') {
				$xx++;
			    }
			    elsif($matrix[$x3][$y3] eq 'Q') {
				$qq++;
			    }
			}
		    }
		    if(($qq > 0) && ($matrix[$x2][$y2]-$xx == 0)) {
			print "Clear around ". $x2.",".$y2."\n";
			for $y3 (max(0, $y2-1) .. min($y, $y2+1)) {
			    for $x3 (max(0, $x2-1) .. min($x, $x2+1)) {
				if($matrix[$x3][$y3] eq 'Q') {
				    return 'position='.$x3.'-'.$y3.'&flag_negg=';
				}
			    }
			}
		    }
		    if(($qq > 0) &&($matrix[$x2][$y2]-$xx == $qq)) {
			print "Bombs around ". $x2.",".$y2."\n";
			for $y3 (max(0, $y2-1) .. min($y, $y2+1)) {
			    for $x3 (max(0, $x2-1) .. min($x, $x2+1)) {
				if($matrix[$x3][$y3] eq 'Q') {
				    return 'position='.$x3.'-'.$y3.'&flag_negg=1';
				}
			    }
			}
		    }	
		}
	    }
	}
    }
    return 0;
}

sub slashdot_clear {
    my $content = shift;
    my $i;
    my @lines;
    @lines = split("\n", $content);

    for $i (4 .. 34) {
	$lines[$i]='';
    }

    $content=join "\n",@lines;

    print "Validating slashdot content\n";
    $content;
}

sub fix_shop {
    my $content = shift;
    my $i;
    my @lines;
    my $clear=0; 
    @lines = split("\n", $content);

    for $i (0..$#lines) {
	if($lines[$i] =~ /<.i><p><table align=center border=0 cellpadding=3>/) {
	    print 'Before:' . $lines[$i] . "\n";
	    $lines[$i] =~ s/^.*<\/i><p><table align=center border=0/<\/i><p><table align=center border=0/;
	    print 'After:' . $lines[$i] . "\n";
	    $clear=0;
	}

	if($clear) {
	    $lines[$i]='';
	}
	if($lines[$i] =~ /^<\/center>/) {
	    $clear=1;
	}
    }

    $content=join "\n",@lines;

    print ") Fixing shop content\n";
    $content;
}

sub ars_clear {
    my $content = shift;
    $content =~ s/<BODY[^<>]*>/<body>/g;
    $content =~ s/<[^<>]*STYLESHEET[^<>]*>/<body>/g;
    $content =~ s/STYLE=\"[^"]*\"//g;
    $content;
}

sub dilbert_clear {
    print "Validating unitedmedia content\n";
    my $content = shift;
    my $i;
    my @lines;
    my $j;
    @lines = split("\n", $content);

    for $i (0 .. $#lines) {
	if($lines[$i] =~ /<.-- Dilbert Ad Tag.*Begin -->/){
	    print "found ad\n";
	    for $j (-2..3) {
		$lines[$i+$j]='';
	    }
	}
    }

    $content=join "\n",@lines;

    $content;
}

sub cliff_hanger_enhance {
    my $content = shift;
    my $i;
    my @lines;
    my @words;
    my $word = "";
    my $j=0;
    my $line = "";
    my $used = "";

    print "Cleaning up cliffhanger\n";

    @lines = split("\n", $content);

    for $i (0 .. $#lines) {
	if($lines[$i] =~ /colspan="2"><b/){
	    $line=$lines[$i];
	    $line =~ s/<br>/&nbsp;/g;
	    $line =~ s/<[^>]*>//g;
	    $line =~ s/ //g;
	    $line =~ s/&nbsp;/ /g;
	    $line =~ s/^ *//g;
	    $line =~ s/ *$//g;
	    # $line =~ s/_/./g;
	    $line =~ tr/A-Z/a-z/;
	    print "Puzzle: " . $line . "\n";
	    }

	if($lines[$i] =~ /solve_puzzle/){
	    $lines[$i] =~ s/value=""/value="$line"/;
	}
	
	if($lines[$i] =~ /FFEFD5/){
	    $used=$lines[$i];
	    $used =~ s/<[^>]*>//g;
	    $used =~ s/\s//g;
	    $used =~ tr/A-Z/a-z/;
	    print "Used: " . $used . "\n";
	}
    }

    $line =~ s/_/[^$used]/g;
    @words = split(" ", $line);
    for $i (0 .. $#words) {
	print "grep '^" . $words[$i] . "\$' /usr/share/dict/words\n"
    }

    $content=join "\n",@lines;

    $content;
}

sub doubleclick_clear {
    my $content = shift;
    $content =~ s/<[^<>]*doubleclick.net[^<>]*>//g;
    $content =~ s/<[^<>]*rmedia.boston.com\/RealMedia\/ads\/[^<>]*>//g;

    $content;
}

sub fetch_validated_request { # return HTTP::Response
  my $request = shift;  # HTTP::Request
  my $response;
  if(!($response=cache_check($request))) {
      $response = $AGENT->request($request);
      if(($response->headers()->content_type() =~ /^image/))
      {
	  if(($request->url() =~ /^http...images.neopets.com./)||
	     ($request->url() =~ /^http...images.slashdot.org./)){
	      image_cache $request, $response;
	  }
      }
  }

  if(($response->headers()->content_type() =~ /text.html/) ||
     ($response->headers()->content_type() =~ /application.x-javascript/)) {
      # Automate NeggSweeper
      if($request->url() eq 'http://www.neopets.com/games/neggsweeper/neggsweeper.phtml') {
	  my $nrc;
	  
	  while(($nrc = negg_parse_content($response->content())) ) {
	      $request->content($nrc);
	      $response = $AGENT->request($request);
	  }
      }

      # Minor aid to cliffhanger
      if($request->url() eq 'http://www.neopets.com/games/cliffhanger/cliffhanger.phtml') {
	  $response->content(cliff_hanger_enhance($response->content()));
      }

      # Fix lame shops
      if($request->url() =~ /http...www.neopets.com.browseshop.phtml.owner/) {
	  $response->content(fix_shop($response->content()));
      }

      
      if($request->url() =~ /^http:\/\/slashdot.org\//) {
	  $response->content(slashdot_clear($response->content()));
      }
      
      if(($request->url() =~ /^http:\/\/www.unitedmedia.com\//)  ||
	 ($request->url() =~ /^http:\/\/www.dilbert.com\//) ) {
	  $response->content(dilbert_clear($response->content()));
      }

      if(($request->url() =~ /http:\/\/[^\/]*\.x10\.com/) ||
	 ($request->url() =~ /http:\/\/cgi.netscape.com\/cgi.bin\/plugins\/get.plugin/)) {
	  $response->content('<html>' .
			     '<body onload="window.close();">' .
			     '</body></html>');
      }

      if($request->url() =~ /^http:\/\/www.arstechnica.com\//) {
	  $response->content(ars_clear($response->content()));
      }
      
#      $response->content(doubleclick_clear($response->content()));
      $response->content(blocklist_clear($response->content()));
  }

  $response;
}
