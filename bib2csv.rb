# -*- coding: utf-8 -*-

require 'bibtex'
require 'citeproc'
require 'csl/styles'
require 'date'

HEADER_PAPER='"タイトル(日本語)","タイトル(英語)","著者(日本語)","著者(英語)","誌名(日本語)","誌名(英語)","巻","号","開始ページ","終了ページ","出版年月","査読の有無","招待の有無","記述言語","掲載種別","ISSN","ID:DOI","ID:JGlobalID","ID:NAID(CiNiiのID)","ID:PMID","Permalink","URL","概要(日本語)","概要(英語)"'
HEADER_CONFERENCE='"タイトル(日本語)","タイトル(英語)","講演者(日本語)","講演者(英語)","会議名(日本語)","会議名(英語)","開催年月日","招待の有無","記述言語","会議区分","会議種別","主催者(日本語)","主催者(英語)","開催地(日本語)","開催地(英語)","URL","概要(日本語)","概要(英語)"'
HEADER_MISC='"タイトル(日本語)","タイトル(英語)","著者(日本語)","著者(英語)","誌名(日本語)","誌名(英語)","巻","号","開始ページ","終了ページ","出版年月","査読の有無","依頼の有無","記述言語","掲載種別","ISSN","ID:DOI","ID:JGlobalID","ID:NAID(CiNiiのID)","ID:PMID","Permalink","URL","概要(日本語)","概要(英語)"'


class BibTeX::Entry
	attr_accessor :x_authors
	attr_accessor :x_title
	attr_accessor :x_locators
	attr_accessor :x_date
	attr_accessor :x_ps
	attr_accessor :x_pe
	attr_accessor :x_lang
	attr_accessor :x_reviewed
	attr_accessor :x_invited
	attr_accessor :x_doi
	attr_accessor :x_paper_type # 論文掲載種別（1: 研究論文（学術雑誌）, 2: 研究論文（国際会議プロシーディングス）, 4: 研究論文（研究会，シンポジウム資料等）, 8: 学術論文（博士））
	attr_accessor :x_presentation_type # 講演・口頭発表用会議種別（1: 口頭発表（一般），4: ポスター発表など））
	attr_accessor :x_category # 会議区分（1: 国内会議, 2: 国際会議）
	attr_accessor :x_misc_type # misc用掲載種別（1: 研究論文，4: 国際会議，5: 全国大会・その他学術会議）

	def to_paper()
		case self.x_lang
		when "ja" then
			return sprintf('"%s","","%s","","%s","","%s","%s","%s","%s","%s","%s","%s","%s","%s","","%s","","","","","","",""',
				self.x_title, self.x_authors, self.x_locators, self['volume'], self['number'], self.x_ps, self.x_pe,
				self.date, self.x_reviewed, self['invited'], self.x_lang, self.x_paper_type, self.x_doi)
		when "en" then
			return sprintf('"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","","%s","","","","","","",""',
				self.x_title, self.x_title,
				self.x_authors, self.x_authors,
				self.x_locators, self.x_locators,
				self['volume'], self['number'], self.x_ps, self.x_pe,
				self.date, self.x_reviewed, self['invited'], self.x_lang, self.x_paper_type, self.x_doi)
		end
	end

	def to_presentation()
		case self.x_lang
		when "ja" then
			return sprintf('"%s","","%s","","%s","","%s","%s","%s","%s","%s","","","","","","",""',
				self.x_title, self.x_authors, self.x_locators, self.date, self.x_invited, self.x_lang, self.x_category, self.x_presentation_type)
		when "en" then
			return sprintf('"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","","","","","","",""',
				self.x_title, self.x_title,
				self.x_authors, self.x_authors,
				self.x_locators, self.x_locators,
				self.date, self.x_invited, self.x_lang, self.x_category, self.x_presentation_type)
		end
	end

	def to_misc()
		case self.x_lang
		when "ja" then
			return sprintf('"%s","","%s","","%s","","%s","%s","%s","%s","%s","%s","%s","%s","%s","","%s","","","","","","",""',
				self.x_title, self.x_authors, self.x_locators, self['volume'], self['number'], self.x_ps, self.x_pe,
				self.date, self.x_reviewed, self['invited'], self.x_lang, self.x_misc_type, self.x_doi)
		when "en" then
			return sprintf('"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","","%s","","","","","","",""',
				self.x_title, self.x_title,
				self.x_authors, self.x_authors,
				self.x_locators, self.x_locators,
				self['volume'], self['number'], self.x_ps, self.x_pe,
				self.date, self.x_reviewed, self['invited'], self.x_lang, self.x_misc_type, self.x_doi)
		end
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
			self.x_lang = "ja"
		when "english", "en" then
			self.x_lang = "en"
		else
			self.x_lang = is_ja(x_authors) || is_ja(x_locators) ? "ja" : "en"
		end

		# 査読の有無
		case self['reviewed'] # 査読フラグがbibtexにあれば，それに従う
		when "1" then
			self.x_reviewed = 1
		when "0" then
			self.x_reviewed = 0
		else # なければ各カテゴリのデフォルトに従う
			case self.type.to_s
			when "article" then # @articleは全て査読あり
				self.x_reviewed = 1
			when "inproceedings" then # @inproceedingsは，英語なら査読あり，日本語なら査読なし
				self.x_reviewed = 1 if self.x_lang == "en"
				self.x_reviewed = 0 if self.x_lang == "ja"
			else # それ以外は全て査読なし
				self.x_reviewed = 0
			end
		end

		# 招待講演かどうか
		case self['invited']
		when "1" then
			self.x_invited = 1
		else
			self.x_invited = 0
		end

		# ページ番号
		if self.pages !~ /^[0-9]+-*[0-9]+$/
			self.x_ps = ""
			self.x_pe = ""
		else
			self.x_ps, self.x_pe = /([0-9]+)-*([0-9]+)/.match(self.pages).captures
		end

		# 年月日
		if !self.month_numeric.nil?
			self.date = sprintf("%04d%02d00", Date.strptime(self.year, "%Y").strftime("%Y"), self.month_numeric)
		else
			self.date = sprintf("%04d0000", Date.strptime(self.year, "%Y").strftime("%Y"))
		end

		# doiの有無
		if !self['doi'].nil?
			self.x_doi = self['doi']
		elsif !self['pdf'].nil? && m = self['pdf'].match(/^https?:\/\/(?:dx.)?doi.org\/(.+)/)
			self.x_doi = m[1]
		elsif !self['url'].nil? && m = self['url'].match(/^https?:\/\/(?:dx.)?doi.org\/(.+)/)
			self.x_doi = m[1]
		end

		# 種別ごとの細かな調整
		case self.type.to_s
		when "article" then
			self.x_paper_type = "1"
			self.x_misc_type = "1"
		when "phdthesis" then
			self.x_paper_type = "8"
			self.x_locators = self["school"]
			self.x_misc_type = "1"
		when "inproceedings" then
			case self.x_lang
			when "ja" then
				self.x_paper_type = 4 if self.x_reviewed == 1
				self.x_presentation_type = "1"
				self.x_category = "1"
				self.x_misc_type = "5"
			when "en" then
				self.x_presentation_type = "1"

				if self['category'] == "1"
					# 国内会議が明記されているなら，それに従う
					self.x_paper_type = "4"
					self.x_category = "1"
					self.x_misc_type = "5"
				else
					# 基本は国内会議．査読ありなら国際会議
					self.x_paper_type = "4"
					self.x_paper_type = "2" if self.x_reviewed == 1

					# 基本は国内会議．査読ありなら国際会議
					self.x_category = "1"
					self.x_category = "2" if self.x_reviewed == 1

					# 基本は国内会議．査読ありなら国際会議
					self.x_misc_type = "5"
					self.x_misc_type = "4" if self.x_reviewed == 1
				end
			end
		end
	end
end

begin
	if ARGV.length != 1
		puts "\nUsage: %s input.bib\n\n\tInput: input.bib\n\tOutput: paper.csv, presentation.csv\n\n" % [ $0 ]
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

	paper = bib['@article,@phdthesis,@inproceedings'].select { |b| b.x_reviewed == 1 }
	File.open('paper.csv', 'w:UTF-8') { |f|
		f.puts HEADER_PAPER
		paper.each do |b|
			f.puts b.to_paper
		end
	}

	presentation = bib['@inproceedings']
	File.open('presentation.csv', 'w:UTF-8') { |f|
		f.puts HEADER_CONFERENCE
		presentation.each do |b|
			f.puts b.to_presentation
		end
	}

	misc = bib['@inproceedings'].select { |b| b.x_reviewed == 0 }
	File.open('misc.csv', 'w:UTF-8') { |f|
		f.puts HEADER_MISC
		misc.each do |b|
			f.puts b.to_misc
		end
	}

rescue => ex
	puts ex.message
	puts $@
end
