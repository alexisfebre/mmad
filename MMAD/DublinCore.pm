package MMAD::DublinCore;

use Modern::Perl;

use base 'Exporter';

use Switch;
use Encode;

our @EXPORT = (
    qw( generate_xml
        lang
        lang2
        types )
);

sub generate_xml {

    my ($row) = @_;

    my $id             = $row->{'Produccion'};
    my $title          = $row->{'Titulo'};
    my $abstract       = $row->{'Resumen'};
    my $creator        = $row->{'Creador'};
    my $subject        = $row->{'Palabra_Clave'};
    my $language       = $row->{'Idioma'};
    my $type           = $row->{'Tipo'};
    my $date           = $row->{'Fecha_Publicacion'};
    my $description    = $row->{'Unidad'};
    my $link           = $row->{'Link'};
    my $academic_grade = $row->{'Grado'};
    my $advisor        = $row->{'Director'};
    my $url            = $row->{'URL'};

    my $desc
        = "Fil: "
        . $creator
        . ". Universidad Nacional de Cordoba. "
        . $description
        . ". Cordoba. Argentina.";

    # Creative Commons

    my ( $rights, $rights_uri );

    $rights     = "Attribution-NonCommercial-ShareAlike 4.0 International";
    $rights_uri = "https://creativecommons.org/licenses/by-nc-sa/4.0/";

    # Encode language

    my $l = encode( "utf-8", $language );

    my $lang = lang($l);

    # Transformers

    my $t = types($type);

    my $lang2 = lang2($lang);

    # Dublin Core XML

    my $dc = XML::Writer->new(
        OUTPUT      => 'self',
        DATA_MODE   => 1,
        DATA_INDENT => 2,
    );

    $dc->xmlDecl( 'UTF-8', 'no' );
    $dc->startTag( 'dublin_core', schema => 'dc' );

    # Abstract

    $dc->startTag(
        'dcvalue',
        element   => 'description',
        qualifier => 'abstract',
        language  => $lang2
    );
    $dc->characters($abstract);
    $dc->endTag('dcvalue');

    # Creative Commons (License)

    $dc->startTag( 'dcvalue', element => 'rights', qualifier => 'none', language => '*' );
    $dc->characters($rights);
    $dc->endTag;

    $dc->startTag( 'dcvalue', element => 'rights', qualifier => 'uri', language => '*' );
    $dc->characters($rights_uri);
    $dc->endTag;

    # Creator

    $dc->startTag( 'dcvalue', element => 'contributor', qualifier => 'author', language => '' );
    $dc->characters($creator);
    $dc->endTag('dcvalue');

    # Advisor

    $dc->startTag( 'dcvalue', element => 'contributor', qualifier => 'advisor', language => '' );
    $dc->characters($advisor);
    $dc->endTag('dcvalue');

    # Date

    $dc->startTag( 'dcvalue', element => 'date', qualifier => 'issued', language => '' );
    $dc->characters($date);
    $dc->endTag('dcvalue');

    # Filiation

    $dc->startTag( 'dcvalue', element => 'description', qualifier => 'fil', language => $lang2 );
    $dc->characters($desc);
    $dc->endTag('dcvalue');

    # Language

    $dc->startTag( 'dcvalue', element => 'language', qualifier => 'iso', language => $lang2 );
    $dc->characters($lang);
    $dc->endTag('dcvalue');

    # Publisher

    $dc->startTag( 'dcvalue', element => 'publisher', qualifier => 'none', language => '' );
    $dc->characters( my $publisher );
    $dc->endTag('dcvalue');

    # Subject

    $dc->startTag( 'dcvalue', element => 'subject', qualifier => 'none', language => $lang2 );
    $dc->characters($subject);
    $dc->endTag('dcvalue');

    # Title

    $dc->startTag( 'dcvalue', element => 'title', qualifier => 'none', language => $lang2 );
    $dc->characters($title);
    $dc->endTag('dcvalue');

    # Type

    $dc->startTag( 'dcvalue', element => 'type', qualifier => 'none', language => $lang2 );
    $dc->characters($t);
    $dc->endTag('dcvalue');

    # Version

    $dc->startTag( 'dcvalue', element => 'description', qualifier => 'version', language => '' );
    $dc->characters('publishedVersion');
    $dc->endTag('dcvalue');

    # URL

    $dc->startTag( 'dcvalue', element => 'url', qualifier => '', language => '' );
    $dc->characters($url);
    $dc->endTag('dcvalue');

    # Others

    if ( $type eq ("Articulo") ) {

        my $volume             = $row->{'Volumen'};
        my $tome               = $row->{'Tomo'};
        my $first_page         = $row->{'Pagina_Inicial'};
        my $last_page          = $row->{'Pagina_Final'};
        my $doi                = $row->{'DOI'};
        my $issn               = $row->{'ISSN'};
        my $eissn              = $row->{'EISSN'};
        my $referato           = $row->{'Referato'};
        my $country            = $row->{'Pais_Edicion'};
        my $city               = $row->{'Ciudad_Edicion'};
        my $disciplinary_field = $row->{'Areas_del_Conocimiento'};
        my $magazine           = $row->{'Revista'};

        my $pagination;

        if ( $first_page && $last_page ) {
            $pagination = $first_page . "-" . $last_page;
        }

        # Volume

        $dc->startTag( 'dcvalue', element => 'journal', qualifier => 'volume', language => '' );
        $dc->characters($volume);
        $dc->endTag('dcvalue');

        # Tome

        $dc->startTag( 'dcvalue', element => 'journal', qualifier => 'tome', language => '' );
        $dc->characters($tome);
        $dc->endTag('dcvalue');

        # Pagination

        $dc->startTag( 'dcvalue', element => 'journal', qualifier => 'pagination', language => '' );
        $dc->characters($pagination);
        $dc->endTag('dcvalue');

        # EISSN

        $dc->startTag( 'dcvalue', element => 'identifier', qualifier => 'eissn', language => '' );
        $dc->characters($eissn);
        $dc->endTag('dcvalue');

        # ISSN

        $dc->startTag( 'dcvalue', element => 'identifier', qualifier => 'issn', language => '' );
        $dc->characters($issn);
        $dc->endTag('dcvalue');

        # Magazine

        $dc->startTag( 'dcvalue', element => 'journal', qualifier => 'title', language => '' );
        $dc->characters($magazine);
        $dc->endTag('dcvalue');

        # Edition country

        $dc->startTag( 'dcvalue', element => 'journal', qualifier => 'country', language => '' );
        $dc->characters($country);
        $dc->endTag('dcvalue');

        # Edition city

        $dc->startTag( 'dcvalue', element => 'journal', qualifier => 'city', language => '' );
        $dc->characters($city);
        $dc->endTag('dcvalue');

        # DOI

        $dc->startTag( 'dcvalue', element => 'doi', qualifier => '', language => '' );
        $dc->characters($doi);
        $dc->endTag('dcvalue');

    }

    if ( $type eq ("Libro") ) {

        my $volumes       = $row->{'Cantidad_Volumenes'},
            my $pages     = $row->{'Cantidad_Paginas'},
            my $isbn      = $row->{'ISBN'},
            my $country   = $row->{'Pais_Edicion'},
            my $city      = $row->{'Ciudad_Edicion'},
            my $editorial = $row->{'Editorial'};

        # Total volumes

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'volumes', language => '' );
        $dc->characters($volumes);
        $dc->endTag('dcvalue');

        # Pages

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'pages', language => '' );
        $dc->characters($pages);
        $dc->endTag('dcvalue');

        # Edition country

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'country', language => '' );
        $dc->characters($country);
        $dc->endTag('dcvalue');

        # Edition city

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'city', language => '' );
        $dc->characters($city);
        $dc->endTag('dcvalue');

        # Editorial

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'editorial', language => '' );
        $dc->characters($editorial);
        $dc->endTag('dcvalue');

        # ISBN

        $dc->startTag( 'dcvalue', element => 'identifier', qualifier => 'isbn', language => '' );
        $dc->characters($isbn);
        $dc->endTag('dcvalue');

    }

    if ( $type eq ("Capitulo de Libro") ) {

        my $volume          = $row->{'Volumen'},
            my $number      = $row->{'Numero'},
            my $first_page  = $row->{'Pagina_Inicial'},
            my $last_page   = $row->{'Pagina_Final'},
            my $isbn        = $row->{'ISBN'},
            my $other_title = $row->{'Titulo_Libro'},
            my $tome        = $row->{'Tomo'},
            my $pages       = $row->{'Total_Paginas'},
            my $country     = $row->{'Pais_Edicion'},
            my $city        = $row->{'Ciudad_Edicion'},
            my $editorial   = $row->{'Editorial'};

        # Alternative title

        $dc->startTag(
            'dcvalue',
            element   => 'title',
            qualifier => 'alternative',
            language  => $lang2
        );
        $dc->characters($other_title);
        $dc->endTag('dcvalue');

        # Volume

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'volume', language => '' );
        $dc->characters($volume);
        $dc->endTag('dcvalue');

        # Tome

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'tome', language => '' );
        $dc->characters($tome);
        $dc->endTag('dcvalue');

        # Number

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'number', language => '' );
        $dc->characters($number);
        $dc->endTag('dcvalue');

        # First page

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'firstpage', language => '' );
        $dc->characters($first_page);
        $dc->endTag('dcvalue');

        # Last page

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'lastpage', language => '' );
        $dc->characters($last_page);
        $dc->endTag('dcvalue');

        # Pages

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'pages', language => '' );
        $dc->characters($pages);
        $dc->endTag('dcvalue');

        # Edition country

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'country', language => '' );
        $dc->characters($country);
        $dc->endTag('dcvalue');

        # Edition city

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'city', language => '' );
        $dc->characters($city);
        $dc->endTag('dcvalue');

        # Editorial

        $dc->startTag( 'dcvalue', element => 'book', qualifier => 'editorial', language => '' );
        $dc->characters($editorial);
        $dc->endTag('dcvalue');

        # ISBN

        $dc->startTag( 'dcvalue', element => 'identifier', qualifier => 'isbn', language => '' );
        $dc->characters($isbn);
        $dc->endTag('dcvalue');

    }

    if ( $type eq ("Congreso") ) {

        my $publication_type = $row->{'Tipo_Publicacion'};
        my $work_type        = $row->{'Tipo_Trabajo'};
        my $magazine         = $row->{'Revista'};
        my $country          = $row->{'Pais_Edicion'};
        my $city             = $row->{'Ciudad_Edicion'};
        my $editorial        = $row->{'Editorial'};
        my $event            = $row->{'Evento'};
        my $event_type       = $row->{'Tipo_Evento'};
        my $event_country    = $row->{'Pais_Evento'};
        my $event_city       = $row->{'Ciudad_Evento'};
        my $event_date       = $row->{'Fecha_Evento'};
        my $institution      = $row->{'Institucion_Organizadora'};

        # Publication type

        $dc->startTag(
            'dcvalue',
            element   => 'conference',
            qualifier => 'publication',
            language  => ''
        );
        $dc->characters($publication_type);
        $dc->endTag('dcvalue');

        # Work type

        $dc->startTag( 'dcvalue', element => 'conference', qualifier => 'work', language => '' );
        $dc->characters($work_type);
        $dc->endTag('dcvalue');

        # Magazine

        $dc->startTag(
            'dcvalue',
            element   => 'conference',
            qualifier => 'magazine',
            language  => ''
        );
        $dc->characters($magazine);
        $dc->endTag('dcvalue');

        # Edition country

        $dc->startTag( 'dcvalue', element => 'conference', qualifier => 'country', language => '' );
        $dc->characters($country);
        $dc->endTag('dcvalue');

        # Edition city

        $dc->startTag( 'dcvalue', element => 'conference', qualifier => 'city', language => '' );
        $dc->characters($city);
        $dc->endTag('dcvalue');

        # Editorial

        $dc->startTag(
            'dcvalue',
            element   => 'conference',
            qualifier => 'editorial',
            language  => ''
        );
        $dc->characters($editorial);
        $dc->endTag('dcvalue');

        # Event

        $dc->startTag( 'dcvalue', element => 'conference', qualifier => 'event', language => '' );
        $dc->characters($city);
        $dc->endTag('dcvalue');

        # Event country

        $dc->startTag(
            'dcvalue',
            element   => 'conference',
            qualifier => 'eventcountry',
            language  => ''
        );
        $dc->characters($event_country);
        $dc->endTag('dcvalue');

        # Event city

        $dc->startTag(
            'dcvalue',
            element   => 'conference',
            qualifier => 'eventcity',
            language  => ''
        );
        $dc->characters($event_city);
        $dc->endTag('dcvalue');

        # Event date

        $dc->startTag(
            'dcvalue',
            element   => 'conference',
            qualifier => 'eventdate',
            language  => ''
        );
        $dc->characters($event_date);
        $dc->endTag('dcvalue');

        # Institution

        $dc->startTag(
            'dcvalue',
            element   => 'conference',
            qualifier => 'institution',
            language  => ''
        );
        $dc->characters($institution);
        $dc->endTag('dcvalue');
    }

    $dc->endTag('dublin_core');

    my $xml = $dc->end();

    return $xml;
}

sub lang {

    my ($lang) = @_;

    my $value;

    switch ($lang) {

        case "Español"   { $value = "spa" }
        case "Inglés"    { $value = "eng" }
        case "Portugués" { $value = "por" }
        else              { $value = "" }

    }

    return $value;

}

sub lang2 {

    my ($lang) = @_;

    my $value;

    switch ($lang) {

        case "spa" { $value = "es" }
        case "eng" { $value = "en" }

    }

    return $value;

}

sub types {

    my ($type) = @_;

    my $value;

    switch ($type) {

        case "Articulo"          { $value = "article" }
        case "Capitulo de Libro" { $value = "bookPart" }
        case "Conferencia"       { $value = "conferenceObject" }
        case "Libro"             { $value = "book" }
        case "Tesis"             { $value = "bachelorThesis" }
        else                     { $value = "" }

    }

    return $value;

}

1;