module AttendancesHelper
  
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出勤' if attenance.started_at.nil?
      return '退勤' if attenance.started_at.present? && attendance.finished_at.nil?
    end
    
    false
  end
end
