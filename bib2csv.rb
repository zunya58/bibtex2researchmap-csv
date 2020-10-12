# -*- coding: utf-8 -*-

require 'bibtex'
require 'citeproc'
require 'csl/styles'
require 'date'

MEMBER_ID = 'YOUR_RESEARCHMAP_ID'

HEADER_PAPER='アクション名,アクションタイプ,類似業績マージ優先度,削除理由,会員ID,タイトル(日本語),タイトル(英語),著者(日本語),著者(英語),担当区分,概要(日本語),概要(英語),出版者・発行元(日本語),出版者・発行元(英語),出版年月,誌名(日本語),誌名(英語),巻,号,開始ページ,終了ページ,記述言語,査読の有無,招待の有無,掲載種別,国際・国内誌,国際共著,DOI,ISSN,eISSN,URL,URL2,主要な業績かどうか,公開の有無'

HEADER_PRESENTATION='アクション名,アクションタイプ,類似業績マージ優先度,削除理由,会員ID,タイトル(日本語),タイトル(英語),講演者(日本語),講演者(英語),会議名(日本語),会議名(英語),発表年月日,開催年月日(From),開催年月日(To),招待の有無,記述言語,会議種別,主催者(日本語),主催者(英語),開催地(日本語),開催地(英語),国名,概要(日本語),概要(英語),国際・国内会議,国際共著,URL,URL2,主要な業績かどうか,公開の有無'

HEADER_MISC='アクション名,アクションタイプ,類似業績マージ優先度,削除理由,会員ID,タイトル(日本語),タイトル(英語),著者(日本語),著者(英語),担当区分,概要(日本語),概要(英語),出版者・発行元(日本語),出版者・発行元(英語),出版年月,誌名(日本語),誌名(英語),巻,号,開始ページ,終了ページ,記述言語,査読の有無,招待の有無,掲載種別,国際・国内誌,国際共著,DOI,ISSN,eISSN,URL,URL2,主要な業績かどうか,公開の有無'

class BibTeX::Entry
	attr_accessor :x_authors
	attr_accessor :x_title
	attr_accessor :x_locators
	attr_accessor :x_date
	# 開始ページ
	attr_accessor :x_page_start
	# 終了ページ
	attr_accessor :x_page_end
	# 記述言語
	#	jpn: 日本語
	#	eng: 英語
	attr_accessor :x_lang
	# 査読の有無
	#	true: あり
	#	false: なし
	attr_accessor :x_reviewed
	# 招待の有無
	#	true: あり
	#	false: なし
	attr_accessor :x_invited
	attr_accessor :x_doi
	# 論文掲載種別
	#	scientific_journal: 研究論文（学術雑誌）
	#	international_conference_proceedings: 研究論文（国際会議プロシーディングス）
	#	research_institution: 研究論文（大学，研究機関等紀要）
	#	symposium: 研究論文（研究会，シンポジウム資料等）
	#	research_society: 研究論文（その他学術会議資料等）
	#	in_book: 論文集(書籍)内論文
	#	master_thesis: 学位論文（修士）
	#	doctoral_thesis: 学位論文（博士）
	#	others: 学位論文（その他）
	attr_accessor :x_paper_type
	# 講演・口頭発表用会議種別
	#	oral_presentation: 口頭発表（一般）
	#	invited_oral_presentation: 口頭発表（招待・特別）
	#	keynote_oral_presentation: 口頭発表（基調）
	#	poster_presentation: ポスター発表
	#	public_symposium: シンポジウム・ワークショップ パネル（公募）
	#	nominated_symposium: シンポジウム・ワークショップ パネル（指名）
	#	public_discourse: 公開講演，セミナー，チュートリアル，講習，講義等
	#	media_report: メディア報道等
	#	others: その他
	attr_accessor :x_presentation_type
	# 会議区分
	#	false: 国内会議
	#	true: 国際会議
	attr_accessor :x_category
	# misc用掲載種別
	#	report_scientific_journal: 速報，短報，研究ノート等（学術雑誌）
	#	report_research_institution: 速報，短報，研究ノート等（大学，研究機関紀要）
	#	summary_international_conference: 研究発表ペーパー・要旨（国際会議）
	#	summary_national_conference: 研究発表ペーパー・要旨（全国大会，その他学術会議）
	#	technical_report: 機関テクニカルレポート，技術報告書，プレプリント等
	#	introduction_scientific_journal: 記事・総説・解説・論説等（学術雑誌）
	#	introduction_international_proceedings: 記事・総説・解説・論説等（国際会議プロシーディングズ）
	#	introduction_research_institution: 記事・総説・解説・論説等（大学・研究所紀要）
	#	introduction_commerce_magazine: 記事・総説・解説・論説等（商業誌、新聞、ウェブメディア）
	#	introduction_other: 記事・総説・解説・論説等（その他）
	#	lecture_materials: 講演資料等（セミナー，チュートリアル，講習，講義他）
	#	book_review: 書評論文，書評，文献紹介等
	#	meeting_report: 会議報告等
	#	others: その他
	attr_accessor :x_misc_type
	# 開催地
	attr_accessor :x_address

	def to_paper()
		is_display = self.x_reviewed == 'true'? 'disclosed' : 'closed'
		return sprintf('insert,force,null,null,%s,"%s","%s","[%s]","[%s]",null,null,null,null,null,%s,"%s","%s",%s,%s,%s,%s,%s,%s,%s,%s,null,null,%s,null,null,null,null,false,"%s"',
			MEMBER_ID, self.x_title, self.x_title, self.x_authors, self.x_authors, self.date,self.x_locators,
			self.x_locators, self['volume'], self['number'],self.x_page_start, self.x_page_end, self.x_lang, self.x_reviewed,
			self.x_invited, self.x_paper_type, self.x_doi, is_display)
	end

	def to_presentation()
		is_display = self.x_reviewed == 'true'? 'closed' : 'disclosed'
		return sprintf('insert,force,null,null,%s,"%s","%s","[%s]","[%s]","%s","%s",%s,null,null,%s,%s,%s,null,null,"%s","%s",null,null,null,%s,null,null,null,false,"%s"',
			MEMBER_ID, self.x_title, self.x_title, self.x_authors, self.x_authors, self.x_locators, self.x_locators,
			self.date, self.x_invited, self.x_lang, self.x_presentation_type, self.x_address, self.x_address, self.x_category,
			is_display)
	end

	def to_misc()
		return sprintf('insert,force,null,null,%s,"%s","%s","[%s]","[%s]",null,null,null,null,null,%s,"%s","%s",%s,%s,%s,%s,%s,%s,%s,%s,null,null,%s,null,null,%s,null,false,disclosed',
			MEMBER_ID, self.x_title, self.x_title, self.x_authors, self.x_authors, self.date,
			self.x_locators, self.x_locators, self['volume'], self['number'], self.x_page_start, self.x_page_end,
			self.x_lang, self.x_reviewed, self.x_invited, self.x_misc_type, self.x_doi, self.x_url)
	end

	def is_ja(txt)
		return txt =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/ ? true : false
	end

	def update(cp)
		x = cp.render :bibliography, id: self.key
		x = x[0].split("\t")
		self.x_authors = BibTeX::Value.new(x[0]).to_s(:filter => :latex)
		self.x_title = BibTeX::Value.new(x[1]).to_s(:filter => :latex)
		self.x_locators = BibTeX::Value.new(x[2]).to_s(:filter => :latex)

		# 言語
		case self['language']
		when "japanese", "ja" then
			self.x_lang = "jpn"
		when "english", "en" then
			self.x_lang = "eng"
		else
			self.x_lang = is_ja(x_authors) || is_ja(x_locators) ? "jpn" : "eng"
		end

		# 開催地
		self.x_address = self['address']

		# 査読の有無
		case self['reviewed'] # 査読フラグがbibtexにあれば，それに従う
		when "1" then
			self.x_reviewed = 'true'
		when "0" then
			self.x_reviewed = 'false'
		else # なければ各カテゴリのデフォルトに従う
			case self.type.to_s
			when "article" then # @articleは全て査読あり
				self.x_reviewed = 'true'
			when "inproceedings" then # @inproceedingsは，英語なら査読あり，日本語なら査読なし
				self.x_reviewed = 'true' if self.x_lang == "eng"
				self.x_reviewed = 'false' if self.x_lang == "jpn"
			when "phdthesis" then # 博士論文は査読あり
				self.x_reviewed = 'true'
			when "masterthesis" then # 修士論文は査読あり
				self.x_reviewed = 'true'
			else # それ以外は全て査読なし
				self.x_reviewed = 'false'
			end
		end

		# 招待講演かどうか，bibファイルで設定があるときのみ、招待ありとする
		case self['invited']
		when "1" then
			self.x_invited = 'true'
		else
			self.x_invited = 'false'
		end

		# ページ番号
		if self.pages !~ /^[0-9]+-*[0-9]+$/
			self.x_page_start = ""
			self.x_page_end = ""
		else
			self.x_page_start, self.x_page_end = /([0-9]+)-*([0-9]+)/.match(self.pages).captures
		end

		# 年月日
		if !self.month_numeric.nil?
			self.date = sprintf("%04d-%02d", Date.strptime(self.year, "%Y").strftime("%Y"), self.month_numeric)
		else
			self.date = sprintf("%04d", Date.strptime(self.year, "%Y").strftime("%Y"))
		end

		# doiの有無
		if !self['doi'].nil?
			self.x_doi = self['doi']
		elsif !self['pdf'].nil? && m = self['pdf'].match(/^https?:\/\/(?:dx.)?doi.org\/(.+)/)
			self.x_doi = m[1]
		elsif !self['url'].nil? && m = self['url'].match(/^https?:\/\/(?:dx.)?doi.org\/(.+)/)
			self.x_doi = m[1]
		end

		puts self.type.to_s

		# 種別ごとの細かな調整
		case self.type.to_s
		when "article" then
			self.x_paper_type = "scientific_journal"
		when "masterthesis" then
			self.x_paper_type = "master_thesis"
			self.x_locators = self["school"]
		when "phdthesis" then
			self.x_paper_type = "doctoral_thesis"
			self.x_locators = self["school"]
		when "inproceedings" then
			# 会議種別が明示的に指定されていればそれを設定．なければ口頭発表
			if self['presentation_type'] != nil
				self.x_presentation_type = self['presentation_type']
			else
				self.x_presentation_type = "oral_presentation"
			end

			case self.x_lang
			when "jpn" then
				self.x_paper_type = 'symposium'
				self.x_category = "false"
			when "eng" then
				self.x_paper_type = 'international_conference_proceedings'

				if self['category'] == "1"
					# 国内会議が明記されているなら，それに従う
					self.x_paper_type = "symposium"
					self.x_category = "false"
				else
					# 基本は国内会議．査読ありなら国際会議
					self.x_paper_type = "symposium"
					self.x_paper_type = "international_conference_proceedings" if self.x_reviewed == 'true'

					# 基本は国内会議．査読ありなら国際会議
					self.x_category = "false"
					self.x_category = "true" if self.x_reviewed == 'true'
				end
			end
		when "techreport" then
			self.x_misc_type = 'technical_report'
			if self['institution'] != nil
				self.x_locators = self['institution']
			elsif self['eprinttype'] != nil
				self.x_locators = self['eprinttype']
			end

			self.x_url = self['url']
		end
	end
end

begin
	if ARGV.length != 1
		puts "\nUsage: %s input.bib\n\n\tInput: input.bib\n\tOutput: paper.csv, presentation.csv, misc.csv\n\n" % [ $0 ]
		exit
	end

	unless File.exist?(ARGV[0])
		puts "[ERROR] cannot open: %s\n" % [ ARGV[0] ]
		exit
	end

	bib = BibTeX.open(ARGV[0])
	bib.replace_strings
	bib.join_strings

	cp = CiteProc::Processor.new style: 'bib2csv', format: 'text'
	cp.import bib.to_citeproc

	bib['@*'].each do |b|
		b.update(cp)
	end

	#paper = bib['@article,@inproceedings'].select { |b| b.x_reviewed == 1 }
	paper = bib['@article,@inproceedings,@phdthesis,@masterthesis']
	File.open('paper.csv', 'w:UTF-8') { |f|
		f.puts 'published_papers'
		f.puts HEADER_PAPER
		paper.each do |b|
			f.puts b.to_paper
		end
	}

	presentation = bib['@inproceedings']
	File.open('presentation.csv', 'w:UTF-8') { |f|
		f.puts 'presentations'
		f.puts HEADER_PRESENTATION
		presentation.each do |b|
			f.puts b.to_presentation
		end
	}

	misc = bib['@techreport']
	File.open('misc.csv', 'w:UTF-8') { |f|
		f.puts 'misc'
		f.puts HEADER_MISC
		misc.each do |b|
			f.puts b.to_misc
		end
	}

rescue => ex
	puts ex.message
	puts $@
end
