<?php

function get_document_meta($file_content) {
    $re = '/(.*) por:[ \t\n]+(.*)[ \t\n]+(.*)((.*) por:[ \t\n]+(.*)[ \t\n]+(.*))+/m';
    preg_match_all($re, $file_content, $matches, PREG_SET_ORDER, 0);

    if(count($matches) == 0) {
        return [
            'title' => substr($file_content, 0, stripos($file_content, "\n")),
            'change' => '',
            'changer' => ''
        ];
    }

    print_r($matches);

    return [
        'title' => $matches[0][3],
        'change' => $matches[0][1],
        'changer' => $matches[0][2]
    ];
}

function remove_accents($string) {
    if ( !preg_match('/[\x80-\xff]/', $string) )
        return $string;

    $chars = array(
    // Decompositions for Latin-1 Supplement
    chr(195).chr(128) => 'A', chr(195).chr(129) => 'A',
    chr(195).chr(130) => 'A', chr(195).chr(131) => 'A',
    chr(195).chr(132) => 'A', chr(195).chr(133) => 'A',
    chr(195).chr(135) => 'C', chr(195).chr(136) => 'E',
    chr(195).chr(137) => 'E', chr(195).chr(138) => 'E',
    chr(195).chr(139) => 'E', chr(195).chr(140) => 'I',
    chr(195).chr(141) => 'I', chr(195).chr(142) => 'I',
    chr(195).chr(143) => 'I', chr(195).chr(145) => 'N',
    chr(195).chr(146) => 'O', chr(195).chr(147) => 'O',
    chr(195).chr(148) => 'O', chr(195).chr(149) => 'O',
    chr(195).chr(150) => 'O', chr(195).chr(153) => 'U',
    chr(195).chr(154) => 'U', chr(195).chr(155) => 'U',
    chr(195).chr(156) => 'U', chr(195).chr(157) => 'Y',
    chr(195).chr(159) => 's', chr(195).chr(160) => 'a',
    chr(195).chr(161) => 'a', chr(195).chr(162) => 'a',
    chr(195).chr(163) => 'a', chr(195).chr(164) => 'a',
    chr(195).chr(165) => 'a', chr(195).chr(167) => 'c',
    chr(195).chr(168) => 'e', chr(195).chr(169) => 'e',
    chr(195).chr(170) => 'e', chr(195).chr(171) => 'e',
    chr(195).chr(172) => 'i', chr(195).chr(173) => 'i',
    chr(195).chr(174) => 'i', chr(195).chr(175) => 'i',
    chr(195).chr(177) => 'n', chr(195).chr(178) => 'o',
    chr(195).chr(179) => 'o', chr(195).chr(180) => 'o',
    chr(195).chr(181) => 'o', chr(195).chr(182) => 'o',
    chr(195).chr(182) => 'o', chr(195).chr(185) => 'u',
    chr(195).chr(186) => 'u', chr(195).chr(187) => 'u',
    chr(195).chr(188) => 'u', chr(195).chr(189) => 'y',
    chr(195).chr(191) => 'y',
    // Decompositions for Latin Extended-A
    chr(196).chr(128) => 'A', chr(196).chr(129) => 'a',
    chr(196).chr(130) => 'A', chr(196).chr(131) => 'a',
    chr(196).chr(132) => 'A', chr(196).chr(133) => 'a',
    chr(196).chr(134) => 'C', chr(196).chr(135) => 'c',
    chr(196).chr(136) => 'C', chr(196).chr(137) => 'c',
    chr(196).chr(138) => 'C', chr(196).chr(139) => 'c',
    chr(196).chr(140) => 'C', chr(196).chr(141) => 'c',
    chr(196).chr(142) => 'D', chr(196).chr(143) => 'd',
    chr(196).chr(144) => 'D', chr(196).chr(145) => 'd',
    chr(196).chr(146) => 'E', chr(196).chr(147) => 'e',
    chr(196).chr(148) => 'E', chr(196).chr(149) => 'e',
    chr(196).chr(150) => 'E', chr(196).chr(151) => 'e',
    chr(196).chr(152) => 'E', chr(196).chr(153) => 'e',
    chr(196).chr(154) => 'E', chr(196).chr(155) => 'e',
    chr(196).chr(156) => 'G', chr(196).chr(157) => 'g',
    chr(196).chr(158) => 'G', chr(196).chr(159) => 'g',
    chr(196).chr(160) => 'G', chr(196).chr(161) => 'g',
    chr(196).chr(162) => 'G', chr(196).chr(163) => 'g',
    chr(196).chr(164) => 'H', chr(196).chr(165) => 'h',
    chr(196).chr(166) => 'H', chr(196).chr(167) => 'h',
    chr(196).chr(168) => 'I', chr(196).chr(169) => 'i',
    chr(196).chr(170) => 'I', chr(196).chr(171) => 'i',
    chr(196).chr(172) => 'I', chr(196).chr(173) => 'i',
    chr(196).chr(174) => 'I', chr(196).chr(175) => 'i',
    chr(196).chr(176) => 'I', chr(196).chr(177) => 'i',
    chr(196).chr(178) => 'IJ',chr(196).chr(179) => 'ij',
    chr(196).chr(180) => 'J', chr(196).chr(181) => 'j',
    chr(196).chr(182) => 'K', chr(196).chr(183) => 'k',
    chr(196).chr(184) => 'k', chr(196).chr(185) => 'L',
    chr(196).chr(186) => 'l', chr(196).chr(187) => 'L',
    chr(196).chr(188) => 'l', chr(196).chr(189) => 'L',
    chr(196).chr(190) => 'l', chr(196).chr(191) => 'L',
    chr(197).chr(128) => 'l', chr(197).chr(129) => 'L',
    chr(197).chr(130) => 'l', chr(197).chr(131) => 'N',
    chr(197).chr(132) => 'n', chr(197).chr(133) => 'N',
    chr(197).chr(134) => 'n', chr(197).chr(135) => 'N',
    chr(197).chr(136) => 'n', chr(197).chr(137) => 'N',
    chr(197).chr(138) => 'n', chr(197).chr(139) => 'N',
    chr(197).chr(140) => 'O', chr(197).chr(141) => 'o',
    chr(197).chr(142) => 'O', chr(197).chr(143) => 'o',
    chr(197).chr(144) => 'O', chr(197).chr(145) => 'o',
    chr(197).chr(146) => 'OE',chr(197).chr(147) => 'oe',
    chr(197).chr(148) => 'R',chr(197).chr(149) => 'r',
    chr(197).chr(150) => 'R',chr(197).chr(151) => 'r',
    chr(197).chr(152) => 'R',chr(197).chr(153) => 'r',
    chr(197).chr(154) => 'S',chr(197).chr(155) => 's',
    chr(197).chr(156) => 'S',chr(197).chr(157) => 's',
    chr(197).chr(158) => 'S',chr(197).chr(159) => 's',
    chr(197).chr(160) => 'S', chr(197).chr(161) => 's',
    chr(197).chr(162) => 'T', chr(197).chr(163) => 't',
    chr(197).chr(164) => 'T', chr(197).chr(165) => 't',
    chr(197).chr(166) => 'T', chr(197).chr(167) => 't',
    chr(197).chr(168) => 'U', chr(197).chr(169) => 'u',
    chr(197).chr(170) => 'U', chr(197).chr(171) => 'u',
    chr(197).chr(172) => 'U', chr(197).chr(173) => 'u',
    chr(197).chr(174) => 'U', chr(197).chr(175) => 'u',
    chr(197).chr(176) => 'U', chr(197).chr(177) => 'u',
    chr(197).chr(178) => 'U', chr(197).chr(179) => 'u',
    chr(197).chr(180) => 'W', chr(197).chr(181) => 'w',
    chr(197).chr(182) => 'Y', chr(197).chr(183) => 'y',
    chr(197).chr(184) => 'Y', chr(197).chr(185) => 'Z',
    chr(197).chr(186) => 'z', chr(197).chr(187) => 'Z',
    chr(197).chr(188) => 'z', chr(197).chr(189) => 'Z',
    chr(197).chr(190) => 'z', chr(197).chr(191) => 's'
    );

    $string = strtr($string, $chars);

    return $string;
}

$shortopts  = "";
$shortopts .= "r::";
$shortopts .= "q::";

$longopts  = array(
    "data-dir:",
    "output-file:",
    "recreate::",
    "quiet::"
);

$options = getopt($shortopts, $longopts);

$original_data_dir_path = dirname(__FILE__) . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'data';

$data_dir_path = isset($options['data-dir']) ? $options['data-dir'] : $original_data_dir_path;
$idx_file_path = isset($options['output-file']) ? $options['output-file'] : $data_dir_path . DIRECTORY_SEPARATOR . 'sqlite' . DIRECTORY_SEPARATOR . 'dados-uffs-idx.sqlite';
$recreate = isset($options['recreate']) || isset($options['r']);
$quiet = isset($options['quiet']) || isset($options['q']);

$idx_dir_path = dirname($idx_file_path);

if(!file_exists($data_dir_path)) {
    echo "Unable to access directory provided by --data-dir: '$data_dir_path'\n";
    exit(1);
}

if(!is_writable($idx_dir_path)) {
    echo "Directory provided by --output-file in unavailable: '$idx_dir_path'\n";
    exit(2);
}

if($recreate) {
    @unlink($idx_file_path);
}

try {
    $db = new PDO('sqlite:' . $idx_file_path);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    if($recreate) {
        $db->exec('CREATE TABLE "documentos" (
            "path" TEXT,
            "ano" INTEGER,
            "numero" INTEGER,
            "tipo" TEXT COLLATE NOCASE,
            "emissor" TEXT COLLATE NOCASE,
            "titulo" TEXT COLLATE NOCASE,
            "modificacao" TEXT COLLATE NOCASE,
            "modificador" TEXT COLLATE NOCASE,
            "conteudo" TEXT COLLATE NOCASE
        )');

        $db->exec('CREATE TABLE "professores" (
            "nome" TEXT COLLATE NOCASE,
            "nome_limpo" TEXT COLLATE NOCASE
        )');
    }
/*
    $historic_file_path = $data_dir_path . DIRECTORY_SEPARATOR . 'csv' . DIRECTORY_SEPARATOR . 'graduacao_historico' . DIRECTORY_SEPARATOR . 'graduacao_historico.csv';

    $handle = fopen($historic_file_path, "r");
    $key_target_header = null;
    $names = [];

    while(($row = fgetcsv($handle)) !== FALSE) {
        if($key_target_header === null) {
            $key_target_header = array_search('lista_docentes_ch', $row);

            if($key_target_header === false) {
                echo "File 'graduacao_historico.csv' has no column 'lista_docentes_ch'\n";
                exit(4);
            }
            continue;
        }

        $data_json = $row[$key_target_header];
        $data = json_decode($data_json);

        if(!is_array($data) || count($data) == 0) {
            if(!$quiet) {
                echo "Warning: empty target in row " . $row[0] . "\n";
            }
            continue;
        }

        foreach($data as $participation) {
            $names[$participation->docente] = true;
        }
    }

    echo 'Adding names to index (' . count($names) . ' in total) ';

    // Professors
    $db->beginTransaction();

    foreach($names as $name => $exists) {
        $qry = $db->prepare('INSERT INTO professores (nome, nome_limpo) VALUES (?, ?)');
        $qry->execute([$name, remove_accents($name)]);
    }

    $db->commit();
    echo "[OK]\n";
*/
    // Docs
    $db->beginTransaction();

    $docs_dir_path = $data_dir_path . DIRECTORY_SEPARATOR . 'text';
    $rii = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($docs_dir_path));
    
    echo "Adding docs to index:\n";

    foreach($rii as $file) {
        if ($file->isDir() || $file->getExtension() != 'plain'){ 
            continue;
        }

        $name = $file->getBasename('.plain');
        $identification = str_replace($docs_dir_path . DIRECTORY_SEPARATOR, '', $file->getPathname());
        $parts = explode(DIRECTORY_SEPARATOR, $identification);

        $year = (int)$parts[0];
        $type = $parts[2];
        $issuer = $parts[3];
        $number = (int)substr($name, stripos($name, '-') + 1);

        $file_content = file_get_contents($file->getPathname());
        $document_meta = get_document_meta($file_content);

        echo "- $identification\n";

        $qry = $db->prepare('INSERT INTO documentos (path, ano, numero, tipo, emissor, titulo, modificacao, modificador, conteudo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)');
        $qry->execute([
            $identification,
            $year,
            $number,
            $type,
            $issuer,
            $document_meta['title'],
            $document_meta['change'],
            $document_meta['changer'],
            $file_content
        ]);
    }

    $db->commit();
    echo "All docs added!\n";

} catch (Exception $e) {
    echo $e->getMessage();
    exit(3);
}
