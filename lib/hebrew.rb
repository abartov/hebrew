# Some useful Hebrew manipulation routines
#
# @author Asaf Bartov <asaf.bartov@gmail.com>
#


NIKKUD_CP1255 = ["\xc0".force_encoding('windows-1255'), "\xc1".force_encoding('windows-1255'), "\xc2".force_encoding('windows-1255'), "\xc3".force_encoding('windows-1255'), "\xc4".force_encoding('windows-1255'), "\xc5".force_encoding('windows-1255'), "\xc6".force_encoding('windows-1255'), "\xc7".force_encoding('windows-1255'), "\xc8".force_encoding('windows-1255'), "\xc9".force_encoding('windows-1255'), "\xcb".force_encoding('windows-1255'), "\xcc".force_encoding('windows-1255'), "\xd1".force_encoding('windows-1255'), "\xd2".force_encoding('windows-1255')] # wow, this is fugly.  Is there a neater way to specify CP1255 literal?
NIKKUD_UTF8 = ["\u05b0", "\u05b1", "\u05b2", "\u05b3", "\u05b4", "\u05b5", "\u05b6", "\u05b7", "\u05b8", "\u05b9", "\u05bb", "\u05bc", "\u05c1", "\u05c2"]
# TODO: Mac encoding

# extend String class
class String
  # this will return the string, stripped of any Hebrew nikkud characters
  def strip_nikkud
    target = ''
    self.each_char {|c|
      unless is_nikkud(c)
        target += c 
      end
    }
    return target
  end
  # TODO: add strip_nikkud!
  def is_nikkud(c)
    self.class.is_nikkud_by_encoding(c, self.encoding) # delegate to class method based on instance encoding
  end
  def self.is_nikkud_by_encoding(c, encoding)
    case encoding
    when Encoding::UTF_8
      # DBG: puts "utf8 - #{c} - #{c.codepoints.first}"
      NIKKUD_UTF8.include?(c)
    when Encoding::WINDOWS_1255 || Encoding::CP1255
      puts "cp1255 - #{c} - #{c.codepoints.first}"
      NIKKUD_CP1255.include?(c)
    # TODO: add Mac encoding?
    end
  end
end
