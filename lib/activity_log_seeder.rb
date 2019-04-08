require 'csv'

module ActivityLogSeeder
  def self.import!(csv_file)
    File.foreach(csv_file) do |row|
      next if row.starts_with?('object_id') # header row
      # Inspired by https://stackoverflow.com/a/14534628
      row = row.gsub(/(?<!\\)\\"/, '""')
      data = CSV.parse(row).first

      attrs = %i(object_id object_type timestamp object_changes).zip(data).to_h
      attrs[:object_changes] = JSON.parse(attrs[:object_changes])

      log = ActivityLog.new(attrs)
      unless log.valid?
        Rails.logger.info "Skipping row: #{row}"
        Rails.logger.info "With error: #{log.errors.full_messages}"
        next
      end
      log.save!
    end

    Rails.logger.info "Completed importing the csv file - #{csv_file.path}"
    csv_file.close
  end
end
