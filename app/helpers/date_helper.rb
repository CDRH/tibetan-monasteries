module DateHelper
  include Orchid::DateHelper

  def date_standardize(date, before=true)
    if date
      y, m, d = date.split(/-|\//)
      if y && y.length == 4
        # use -1 to indicate that this will be the last possible
        m_default = before ? "01" : "-1"
        d_default = before ? "01" : "-1"
        m = m_default if !m
        d = d_default if !d
        if Date.valid_date?(y.to_i, m.to_i, d.to_i)
          date = Date.new(y.to_i, m.to_i, d.to_i)
          date.strftime("%Y-%m-%d")
        end
      end
    end
  end
  
end